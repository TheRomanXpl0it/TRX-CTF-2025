open SMLofNJ.Cont;

datatype Exp = Const of int | Var of string | Sum of Exp * Exp | Sub of Exp * Exp | Mul of Exp * Exp | Div of Exp * Exp;
datatype Bool = True | False | And of Bool * Bool | Or of Bool * Bool | Not of Bool | Eq of Exp * Exp | Gt of Exp * Exp | Lt of Exp * Exp;
datatype Program = Skip | Seq of Program * Program | Assign of string * Exp | If of Bool * Program * Program | While of Bool * Program | Sync | Crit of Program;
datatype Thread = Null | Th of Program * Thread;

exception NotFoundException;

fun findElementByKey(key: string, lst: (string * int) list): int =
	case lst of
		[] => raise NotFoundException
		| (k,v) :: rest =>
			if k = key then
				v
			else
				findElementByKey(key, rest);


fun evalM(E:(string * int) list, M:Exp):int = 
	case M of
		Const v => v
		| Var s => findElementByKey(s, E)
		| Sum (e1, e2) => evalM(E, e1) + evalM(E, e2)
		| Sub (e1, e2) => evalM(E, e1) - evalM(E, e2)
		| Mul (e1, e2) => evalM(E, e1) * evalM(E, e2)
		| Div (e1, e2) => evalM(E, e1) div evalM(E, e2);


fun evalB(E:(string * int) list, B:Bool):bool =
	case B of
		True => true 
		| False => false
		| And (a,b) => evalB(E, a) andalso evalB(E, b)
		| Or (a,b) => evalB(E, a) orelse evalB(E, b)
		| Not a => not(evalB(E, a))
		| Eq (a,b) => evalM(E, a) = evalM(E, b)
		| Gt (a,b) => evalM(E, a) > evalM(E, b)
		| Lt (a,b) => evalM(E, a) < evalM(E, b);


fun evalP(E:(string * int) list, p:Program):((string * int) list) = 
	case p of
		Skip => E
		| Seq (q,m) => evalP(evalP(E, q), m)
		| Assign (x, M) => (x, evalM(E,M)) :: E
		| If (b, t, e) => if evalB(E, b) then evalP(E, t) else evalP(E, e)
		| While (b, q) => if evalB(E, b) then evalP(E, Seq(q, p)) else E
		| Crit q => evalP(E, q)
		| Sync => E;


fun evalI(E:(string * int) list, p:Program, k) =
	case p of
		Skip => throw k (E, Skip)
		| Seq (q,m) => throw k let 
			val (E1, q2) = 
				callcc(fn k1 => evalI(E, q, k1))
			in
				if q2 <> Skip then
					(E1, Seq(q2, m))
				else
					(E1, m)
			end
		| Assign (x, M) => throw k ((x, evalM(E,M)) :: E, Skip)
		| If (b, p1, p2) => if evalB(E, b) then throw k (E, p1) else throw k (E, p2)
		| While (b, q) => if evalB(E, b) then throw k (E, Seq(q, p)) else throw k (E, Skip)
		| Crit q => throw k (evalP(E, q), Skip)
		| Sync => throw k (E, p);

fun checkEnd(t:Thread): bool = 
	case t of
		Null => true
		| Th (p1, t1) => (p1 = Skip) andalso checkEnd t1;


fun checkSync(t:Thread): bool =
	case t of
		Null => true
		| Th (p1, t1) => (
			case p1 of
				Skip => false
				| Seq (q,m) => checkSync(Th(q, Null))
				| Assign (x, M) => false
				| If (b, t, e) => false
				| While (b, q) => false
				| Crit q => false
				| Sync => true
			) andalso checkSync t1;


fun removeSyncP(p:Program):Program = 
	case p of
		Sync => Skip
		| Seq (p1,p2) => Seq(removeSyncP p1, p2);


fun removeSync(t:Thread):Thread = 
	case t of 
		Null => Null
		| Th (p1, t1) => Th(removeSyncP p1, removeSync t1)


fun evalTOne(E:(string * int) list, t:Thread) = 
	case t of 
		Null => (E, Null)
		| Th(p1, t1) => 
			let
				val (E1, p1_1) = callcc(fn k1 => evalI(E, p1, k1))
				val (E2, t1_1) = evalTOne(E1, t1)
			in
				(E2, Th(p1_1, t1_1))
			end;


fun evalT(E:(string * int) list, t: Thread): ((string * int) list) =
	case t of 
		Null => E
		| Th (p1, t1) => 
			let
				val (E1, t1_1) = evalTOne(E, Th(p1, t1))
			in
				if checkSync t1_1 then
					evalT(E1, removeSync t1_1)
				else
					if not(checkEnd t1_1) then
						evalT(E1, t1_1)
					else
						E1
			end;


val flag_len = %d;


fun initEnv(str: string) =
	let
		val len = String.size str
	in
		if len = flag_len then
			let
				val arr = Array.array (flag_len + 1, ("", 0)) 
				fun fillArray i =
					if i < flag_len then
						(Array.update (arr, i, ("c_" ^ Int.toString i, Char.ord (String.sub (str, i))));
						 fillArray (i + 1))
					else if i = flag_len then
						(Array.update (arr, i, ("correct", 1));
						 fillArray (i + 1))
					else
						arr
				fun arrayToList arr = Array.foldr (op ::) [] arr
			in
				arrayToList (fillArray 0)
			end
		else
			raise Fail "Flag length mismatch"
	end;


fun check(result:(string * int) list) =
	let
		val correct = findElementByKey("correct", result)
	in
		if correct = 1 then
			print "Correct!\n"
		else
			print "Skill Issue!\n"
	end;



val flag = Option.getOpt (TextIO.inputLine TextIO.stdIn, "NONE\n");
val E = initEnv flag;
val prog = %s;
val result = evalT(E, prog);

check result;
