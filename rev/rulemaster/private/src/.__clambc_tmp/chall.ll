; ModuleID = 'chall.c'
source_filename = "chall.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.__Signatures = type { i8*, %struct.signature }
%struct.signature = type { i64 }

@.str = private unnamed_addr constant [34 x i8] c"Nice_try_but_it_cant_be_this_easy\00", align 1
@__Copyright = dso_local constant i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str, i32 0, i32 0), align 8
@__clambc_virusname_prefix = dso_local constant [14 x i8] c"The_RuleGod..\00", align 1
@.str.1 = private unnamed_addr constant [35 x i8] c"You_read_the_CTF_rules_i_like_that\00", align 1
@.str.2 = private unnamed_addr constant [43 x i8] c"Perfect_form_now_we_just_need_whats_inside\00", align 1
@.str.3 = private unnamed_addr constant [44 x i8] c"Well_thats_a_start_but_its_not_quite_it_yet\00", align 1
@.str.4 = private unnamed_addr constant [38 x i8] c"It_just_needs_a_little_fixing-come_on\00", align 1
@.str.5 = private unnamed_addr constant [20 x i8] c"Congrats_You_got_it\00", align 1
@__clambc_virusnames = dso_local constant [5 x i8*] [i8* getelementptr inbounds ([35 x i8], [35 x i8]* @.str.1, i32 0, i32 0), i8* getelementptr inbounds ([43 x i8], [43 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.5, i32 0, i32 0)], align 16
@__Target = dso_local constant i16 0, align 2
@__FuncMin = dso_local constant i16 56, align 2
@.str.6 = private unnamed_addr constant [11 x i8] c"0:5452587b\00", align 1
@Signatures = dso_local constant %struct.__Signatures { i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.6, i32 0, i32 0), %struct.signature zeroinitializer }, align 8
@__clambc_kind = dso_local constant i16 0, align 2
@__clambc_match_counts = external constant [64 x i32], align 16

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @logical_trigger() #0 {
entry:
  %sig.i = alloca %struct.signature, align 8
  %0 = load i64, i64* getelementptr inbounds (%struct.__Signatures, %struct.__Signatures* @Signatures, i32 0, i32 1, i32 0), align 8
  %coerce.dive.i = getelementptr inbounds %struct.signature, %struct.signature* %sig.i, i32 0, i32 0
  store i64 %0, i64* %coerce.dive.i, align 8
  %id.i = getelementptr inbounds %struct.signature, %struct.signature* %sig.i, i32 0, i32 0
  %1 = load i64, i64* %id.i, align 8
  %arrayidx.i = getelementptr inbounds [64 x i32], [64 x i32]* @__clambc_match_counts, i64 0, i64 %1
  %2 = load i32, i32* %arrayidx.i, align 4
  %cmp.i = icmp ne i32 %2, 0
  %conv.i = zext i1 %cmp.i to i32
  %tobool = icmp ne i32 %conv.i, 0
  ret i1 %tobool
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @entrypoint() #0 {
entry:
  %virusname.addr.i2403 = alloca i8*, align 8
  %virusname.addr.i2401 = alloca i8*, align 8
  %virusname.addr.i2399 = alloca i8*, align 8
  %virusname.addr.i2397 = alloca i8*, align 8
  %virusname.addr.i = alloca i8*, align 8
  %retval = alloca i32, align 4
  %buf = alloca i8, align 1
  %correct = alloca i8, align 1
  %size = alloca i32, align 4
  store i8 1, i8* %correct, align 1
  store i8* getelementptr inbounds ([35 x i8], [35 x i8]* @.str.1, i64 0, i64 0), i8** %virusname.addr.i2403, align 8
  %0 = load i8*, i8** %virusname.addr.i2403, align 8
  %call.i2404 = call i32 @setvirusname(i8* noundef %0, i32 noundef 0) #2
  %call = call i32 @seek(i32 noundef -1, i32 noundef 2)
  store i32 %call, i32* %size, align 4
  %call1 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %1 = load i8, i8* %buf, align 1
  %conv = zext i8 %1 to i32
  %cmp = icmp ne i32 %conv, 125
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 1, i32* %retval, align 4
  br label %return

if.end:                                           ; preds = %entry
  store i8* getelementptr inbounds ([43 x i8], [43 x i8]* @.str.2, i64 0, i64 0), i8** %virusname.addr.i2401, align 8
  %2 = load i8*, i8** %virusname.addr.i2401, align 8
  %call.i2402 = call i32 @setvirusname(i8* noundef %2, i32 noundef 0) #2
  %3 = load i32, i32* %size, align 4
  %add = add nsw i32 %3, 1
  %cmp3 = icmp ne i32 %add, 44
  br i1 %cmp3, label %if.then5, label %if.end6

if.then5:                                         ; preds = %if.end
  store i32 -1, i32* %retval, align 4
  br label %return

if.end6:                                          ; preds = %if.end
  store i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str.3, i64 0, i64 0), i8** %virusname.addr.i2399, align 8
  %4 = load i8*, i8** %virusname.addr.i2399, align 8
  %call.i2400 = call i32 @setvirusname(i8* noundef %4, i32 noundef 0) #2
  %call7 = call i32 @seek(i32 noundef -19, i32 noundef 2)
  %call8 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %5 = load i8, i8* %buf, align 1
  %conv9 = zext i8 %5 to i32
  %and = and i32 %conv9, 1
  %cmp10 = icmp ne i32 %and, 1
  br i1 %cmp10, label %if.then12, label %if.end13

if.then12:                                        ; preds = %if.end6
  store i8 0, i8* %correct, align 1
  br label %if.end13

if.end13:                                         ; preds = %if.then12, %if.end6
  %call14 = call i32 @seek(i32 noundef -8, i32 noundef 2)
  %call15 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %6 = load i8, i8* %buf, align 1
  %conv16 = zext i8 %6 to i32
  %cmp17 = icmp slt i32 %conv16, 78
  br i1 %cmp17, label %if.then19, label %if.end20

if.then19:                                        ; preds = %if.end13
  store i8 0, i8* %correct, align 1
  br label %if.end20

if.end20:                                         ; preds = %if.then19, %if.end13
  %call21 = call i32 @seek(i32 noundef -34, i32 noundef 2)
  %call22 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %7 = load i8, i8* %buf, align 1
  %conv23 = zext i8 %7 to i32
  %or = or i32 %conv23, 30
  %cmp24 = icmp ne i32 %or, 63
  br i1 %cmp24, label %if.then26, label %if.end27

if.then26:                                        ; preds = %if.end20
  store i8 0, i8* %correct, align 1
  br label %if.end27

if.end27:                                         ; preds = %if.then26, %if.end20
  %call28 = call i32 @seek(i32 noundef -6, i32 noundef 2)
  %call29 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %8 = load i8, i8* %buf, align 1
  %conv30 = zext i8 %8 to i32
  %or31 = or i32 %conv30, 2
  %cmp32 = icmp ne i32 %or31, 110
  br i1 %cmp32, label %if.then34, label %if.end35

if.then34:                                        ; preds = %if.end27
  store i8 0, i8* %correct, align 1
  br label %if.end35

if.end35:                                         ; preds = %if.then34, %if.end27
  %call36 = call i32 @seek(i32 noundef -32, i32 noundef 2)
  %call37 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %9 = load i8, i8* %buf, align 1
  %conv38 = zext i8 %9 to i32
  %cmp39 = icmp slt i32 %conv38, 53
  br i1 %cmp39, label %if.then41, label %if.end42

if.then41:                                        ; preds = %if.end35
  store i8 0, i8* %correct, align 1
  br label %if.end42

if.end42:                                         ; preds = %if.then41, %if.end35
  %call43 = call i32 @seek(i32 noundef -8, i32 noundef 2)
  %call44 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %10 = load i8, i8* %buf, align 1
  %conv45 = zext i8 %10 to i32
  %and46 = and i32 %conv45, 45
  %cmp47 = icmp ne i32 %and46, 45
  br i1 %cmp47, label %if.then49, label %if.end50

if.then49:                                        ; preds = %if.end42
  store i8 0, i8* %correct, align 1
  br label %if.end50

if.end50:                                         ; preds = %if.then49, %if.end42
  %call51 = call i32 @seek(i32 noundef 11, i32 noundef 0)
  %call52 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %11 = load i8, i8* %buf, align 1
  %conv53 = zext i8 %11 to i32
  %or54 = or i32 %conv53, 240
  %cmp55 = icmp ne i32 %or54, 255
  br i1 %cmp55, label %if.then57, label %if.end58

if.then57:                                        ; preds = %if.end50
  store i8 0, i8* %correct, align 1
  br label %if.end58

if.end58:                                         ; preds = %if.then57, %if.end50
  %call59 = call i32 @seek(i32 noundef -24, i32 noundef 2)
  %call60 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %12 = load i8, i8* %buf, align 1
  %conv61 = zext i8 %12 to i32
  %cmp62 = icmp slt i32 %conv61, 25
  br i1 %cmp62, label %if.then64, label %if.end65

if.then64:                                        ; preds = %if.end58
  store i8 0, i8* %correct, align 1
  br label %if.end65

if.end65:                                         ; preds = %if.then64, %if.end58
  %call66 = call i32 @seek(i32 noundef -20, i32 noundef 2)
  %call67 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %13 = load i8, i8* %buf, align 1
  %conv68 = zext i8 %13 to i32
  %and69 = and i32 %conv68, 205
  %cmp70 = icmp ne i32 %and69, 77
  br i1 %cmp70, label %if.then72, label %if.end73

if.then72:                                        ; preds = %if.end65
  store i8 0, i8* %correct, align 1
  br label %if.end73

if.end73:                                         ; preds = %if.then72, %if.end65
  %call74 = call i32 @seek(i32 noundef -24, i32 noundef 2)
  %call75 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %14 = load i8, i8* %buf, align 1
  %conv76 = zext i8 %14 to i32
  %cmp77 = icmp slt i32 %conv76, 64
  br i1 %cmp77, label %if.then79, label %if.end80

if.then79:                                        ; preds = %if.end73
  store i8 0, i8* %correct, align 1
  br label %if.end80

if.end80:                                         ; preds = %if.then79, %if.end73
  %call81 = call i32 @seek(i32 noundef 28, i32 noundef 0)
  %call82 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %15 = load i8, i8* %buf, align 1
  %conv83 = zext i8 %15 to i32
  %and84 = and i32 %conv83, 21
  %cmp85 = icmp ne i32 %and84, 21
  br i1 %cmp85, label %if.then87, label %if.end88

if.then87:                                        ; preds = %if.end80
  store i8 0, i8* %correct, align 1
  br label %if.end88

if.end88:                                         ; preds = %if.then87, %if.end80
  %call89 = call i32 @seek(i32 noundef -11, i32 noundef 2)
  %call90 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %16 = load i8, i8* %buf, align 1
  %conv91 = zext i8 %16 to i32
  %cmp92 = icmp sge i32 %conv91, 176
  br i1 %cmp92, label %if.then94, label %if.end95

if.then94:                                        ; preds = %if.end88
  store i8 0, i8* %correct, align 1
  br label %if.end95

if.end95:                                         ; preds = %if.then94, %if.end88
  %call96 = call i32 @seek(i32 noundef 12, i32 noundef 0)
  %call97 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %17 = load i8, i8* %buf, align 1
  %conv98 = zext i8 %17 to i32
  %cmp99 = icmp sge i32 %conv98, 147
  br i1 %cmp99, label %if.then101, label %if.end102

if.then101:                                       ; preds = %if.end95
  store i8 0, i8* %correct, align 1
  br label %if.end102

if.end102:                                        ; preds = %if.then101, %if.end95
  %call103 = call i32 @seek(i32 noundef -10, i32 noundef 2)
  %call104 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %18 = load i8, i8* %buf, align 1
  %conv105 = zext i8 %18 to i32
  %cmp106 = icmp sge i32 %conv105, 146
  br i1 %cmp106, label %if.then108, label %if.end109

if.then108:                                       ; preds = %if.end102
  store i8 0, i8* %correct, align 1
  br label %if.end109

if.end109:                                        ; preds = %if.then108, %if.end102
  %call110 = call i32 @seek(i32 noundef -16, i32 noundef 2)
  %call111 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %19 = load i8, i8* %buf, align 1
  %conv112 = zext i8 %19 to i32
  %and113 = and i32 %conv112, 25
  %cmp114 = icmp ne i32 %and113, 17
  br i1 %cmp114, label %if.then116, label %if.end117

if.then116:                                       ; preds = %if.end109
  store i8 0, i8* %correct, align 1
  br label %if.end117

if.end117:                                        ; preds = %if.then116, %if.end109
  %call118 = call i32 @seek(i32 noundef -15, i32 noundef 2)
  %call119 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %20 = load i8, i8* %buf, align 1
  %conv120 = zext i8 %20 to i32
  %cmp121 = icmp sge i32 %conv120, 229
  br i1 %cmp121, label %if.then123, label %if.end124

if.then123:                                       ; preds = %if.end117
  store i8 0, i8* %correct, align 1
  br label %if.end124

if.end124:                                        ; preds = %if.then123, %if.end117
  %call125 = call i32 @seek(i32 noundef -3, i32 noundef 2)
  %call126 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %21 = load i8, i8* %buf, align 1
  %conv127 = zext i8 %21 to i32
  %or128 = or i32 %conv127, 57
  %cmp129 = icmp ne i32 %or128, 123
  br i1 %cmp129, label %if.then131, label %if.end132

if.then131:                                       ; preds = %if.end124
  store i8 0, i8* %correct, align 1
  br label %if.end132

if.end132:                                        ; preds = %if.then131, %if.end124
  %call133 = call i32 @seek(i32 noundef -39, i32 noundef 2)
  %call134 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %22 = load i8, i8* %buf, align 1
  %conv135 = zext i8 %22 to i32
  %cmp136 = icmp sge i32 %conv135, 55
  br i1 %cmp136, label %if.then138, label %if.end139

if.then138:                                       ; preds = %if.end132
  store i8 0, i8* %correct, align 1
  br label %if.end139

if.end139:                                        ; preds = %if.then138, %if.end132
  %call140 = call i32 @seek(i32 noundef 36, i32 noundef 0)
  %call141 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %23 = load i8, i8* %buf, align 1
  %conv142 = zext i8 %23 to i32
  %and143 = and i32 %conv142, 207
  %cmp144 = icmp ne i32 %and143, 77
  br i1 %cmp144, label %if.then146, label %if.end147

if.then146:                                       ; preds = %if.end139
  store i8 0, i8* %correct, align 1
  br label %if.end147

if.end147:                                        ; preds = %if.then146, %if.end139
  %call148 = call i32 @seek(i32 noundef -19, i32 noundef 2)
  %call149 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %24 = load i8, i8* %buf, align 1
  %conv150 = zext i8 %24 to i32
  %cmp151 = icmp sge i32 %conv150, 115
  br i1 %cmp151, label %if.then153, label %if.end154

if.then153:                                       ; preds = %if.end147
  store i8 0, i8* %correct, align 1
  br label %if.end154

if.end154:                                        ; preds = %if.then153, %if.end147
  %call155 = call i32 @seek(i32 noundef 31, i32 noundef 0)
  %call156 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %25 = load i8, i8* %buf, align 1
  %conv157 = zext i8 %25 to i32
  %and158 = and i32 %conv157, 218
  %cmp159 = icmp ne i32 %and158, 80
  br i1 %cmp159, label %if.then161, label %if.end162

if.then161:                                       ; preds = %if.end154
  store i8 0, i8* %correct, align 1
  br label %if.end162

if.end162:                                        ; preds = %if.then161, %if.end154
  %call163 = call i32 @seek(i32 noundef 39, i32 noundef 0)
  %call164 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %26 = load i8, i8* %buf, align 1
  %conv165 = zext i8 %26 to i32
  %and166 = and i32 %conv165, 127
  %cmp167 = icmp ne i32 %and166, 119
  br i1 %cmp167, label %if.then169, label %if.end170

if.then169:                                       ; preds = %if.end162
  store i8 0, i8* %correct, align 1
  br label %if.end170

if.end170:                                        ; preds = %if.then169, %if.end162
  %call171 = call i32 @seek(i32 noundef 6, i32 noundef 0)
  %call172 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %27 = load i8, i8* %buf, align 1
  %conv173 = zext i8 %27 to i32
  %or174 = or i32 %conv173, 54
  %cmp175 = icmp ne i32 %or174, 119
  br i1 %cmp175, label %if.then177, label %if.end178

if.then177:                                       ; preds = %if.end170
  store i8 0, i8* %correct, align 1
  br label %if.end178

if.end178:                                        ; preds = %if.then177, %if.end170
  %call179 = call i32 @seek(i32 noundef -39, i32 noundef 2)
  %call180 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %28 = load i8, i8* %buf, align 1
  %conv181 = zext i8 %28 to i32
  %or182 = or i32 %conv181, 136
  %cmp183 = icmp ne i32 %or182, 184
  br i1 %cmp183, label %if.then185, label %if.end186

if.then185:                                       ; preds = %if.end178
  store i8 0, i8* %correct, align 1
  br label %if.end186

if.end186:                                        ; preds = %if.then185, %if.end178
  %call187 = call i32 @seek(i32 noundef -22, i32 noundef 2)
  %call188 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %29 = load i8, i8* %buf, align 1
  %conv189 = zext i8 %29 to i32
  %or190 = or i32 %conv189, 158
  %cmp191 = icmp ne i32 %or190, 190
  br i1 %cmp191, label %if.then193, label %if.end194

if.then193:                                       ; preds = %if.end186
  store i8 0, i8* %correct, align 1
  br label %if.end194

if.end194:                                        ; preds = %if.then193, %if.end186
  %call195 = call i32 @seek(i32 noundef -15, i32 noundef 2)
  %call196 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %30 = load i8, i8* %buf, align 1
  %conv197 = zext i8 %30 to i32
  %or198 = or i32 %conv197, 39
  %cmp199 = icmp ne i32 %or198, 119
  br i1 %cmp199, label %if.then201, label %if.end202

if.then201:                                       ; preds = %if.end194
  store i8 0, i8* %correct, align 1
  br label %if.end202

if.end202:                                        ; preds = %if.then201, %if.end194
  %call203 = call i32 @seek(i32 noundef 32, i32 noundef 0)
  %call204 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %31 = load i8, i8* %buf, align 1
  %conv205 = zext i8 %31 to i32
  %and206 = and i32 %conv205, 52
  %cmp207 = icmp ne i32 %and206, 48
  br i1 %cmp207, label %if.then209, label %if.end210

if.then209:                                       ; preds = %if.end202
  store i8 0, i8* %correct, align 1
  br label %if.end210

if.end210:                                        ; preds = %if.then209, %if.end202
  %call211 = call i32 @seek(i32 noundef -34, i32 noundef 2)
  %call212 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %32 = load i8, i8* %buf, align 1
  %conv213 = zext i8 %32 to i32
  %or214 = or i32 %conv213, 178
  %cmp215 = icmp ne i32 %or214, 179
  br i1 %cmp215, label %if.then217, label %if.end218

if.then217:                                       ; preds = %if.end210
  store i8 0, i8* %correct, align 1
  br label %if.end218

if.end218:                                        ; preds = %if.then217, %if.end210
  %call219 = call i32 @seek(i32 noundef -20, i32 noundef 2)
  %call220 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %33 = load i8, i8* %buf, align 1
  %conv221 = zext i8 %33 to i32
  %and222 = and i32 %conv221, 210
  %cmp223 = icmp ne i32 %and222, 82
  br i1 %cmp223, label %if.then225, label %if.end226

if.then225:                                       ; preds = %if.end218
  store i8 0, i8* %correct, align 1
  br label %if.end226

if.end226:                                        ; preds = %if.then225, %if.end218
  %call227 = call i32 @seek(i32 noundef 32, i32 noundef 0)
  %call228 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %34 = load i8, i8* %buf, align 1
  %conv229 = zext i8 %34 to i32
  %cmp230 = icmp sge i32 %conv229, 64
  br i1 %cmp230, label %if.then232, label %if.end233

if.then232:                                       ; preds = %if.end226
  store i8 0, i8* %correct, align 1
  br label %if.end233

if.end233:                                        ; preds = %if.then232, %if.end226
  %call234 = call i32 @seek(i32 noundef -14, i32 noundef 2)
  %call235 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %35 = load i8, i8* %buf, align 1
  %conv236 = zext i8 %35 to i32
  %and237 = and i32 %conv236, 226
  %cmp238 = icmp ne i32 %and237, 32
  br i1 %cmp238, label %if.then240, label %if.end241

if.then240:                                       ; preds = %if.end233
  store i8 0, i8* %correct, align 1
  br label %if.end241

if.end241:                                        ; preds = %if.then240, %if.end233
  %call242 = call i32 @seek(i32 noundef -29, i32 noundef 2)
  %call243 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %36 = load i8, i8* %buf, align 1
  %conv244 = zext i8 %36 to i32
  %or245 = or i32 %conv244, 66
  %cmp246 = icmp ne i32 %or245, 102
  br i1 %cmp246, label %if.then248, label %if.end249

if.then248:                                       ; preds = %if.end241
  store i8 0, i8* %correct, align 1
  br label %if.end249

if.end249:                                        ; preds = %if.then248, %if.end241
  %call250 = call i32 @seek(i32 noundef -28, i32 noundef 2)
  %call251 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %37 = load i8, i8* %buf, align 1
  %conv252 = zext i8 %37 to i32
  %cmp253 = icmp sge i32 %conv252, 133
  br i1 %cmp253, label %if.then255, label %if.end256

if.then255:                                       ; preds = %if.end249
  store i8 0, i8* %correct, align 1
  br label %if.end256

if.end256:                                        ; preds = %if.then255, %if.end249
  %call257 = call i32 @seek(i32 noundef -21, i32 noundef 2)
  %call258 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %38 = load i8, i8* %buf, align 1
  %conv259 = zext i8 %38 to i32
  %or260 = or i32 %conv259, 149
  %cmp261 = icmp ne i32 %or260, 245
  br i1 %cmp261, label %if.then263, label %if.end264

if.then263:                                       ; preds = %if.end256
  store i8 0, i8* %correct, align 1
  br label %if.end264

if.end264:                                        ; preds = %if.then263, %if.end256
  %call265 = call i32 @seek(i32 noundef -11, i32 noundef 2)
  %call266 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %39 = load i8, i8* %buf, align 1
  %conv267 = zext i8 %39 to i32
  %and268 = and i32 %conv267, 255
  %cmp269 = icmp ne i32 %and268, 110
  br i1 %cmp269, label %if.then271, label %if.end272

if.then271:                                       ; preds = %if.end264
  store i8 0, i8* %correct, align 1
  br label %if.end272

if.end272:                                        ; preds = %if.then271, %if.end264
  %call273 = call i32 @seek(i32 noundef 5, i32 noundef 0)
  %call274 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %40 = load i8, i8* %buf, align 1
  %conv275 = zext i8 %40 to i32
  %or276 = or i32 %conv275, 87
  %cmp277 = icmp ne i32 %or276, 119
  br i1 %cmp277, label %if.then279, label %if.end280

if.then279:                                       ; preds = %if.end272
  store i8 0, i8* %correct, align 1
  br label %if.end280

if.end280:                                        ; preds = %if.then279, %if.end272
  %call281 = call i32 @seek(i32 noundef 33, i32 noundef 0)
  %call282 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %41 = load i8, i8* %buf, align 1
  %conv283 = zext i8 %41 to i32
  %or284 = or i32 %conv283, 35
  %cmp285 = icmp ne i32 %or284, 111
  br i1 %cmp285, label %if.then287, label %if.end288

if.then287:                                       ; preds = %if.end280
  store i8 0, i8* %correct, align 1
  br label %if.end288

if.end288:                                        ; preds = %if.then287, %if.end280
  %call289 = call i32 @seek(i32 noundef 42, i32 noundef 0)
  %call290 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %42 = load i8, i8* %buf, align 1
  %conv291 = zext i8 %42 to i32
  %and292 = and i32 %conv291, 106
  %cmp293 = icmp ne i32 %and292, 34
  br i1 %cmp293, label %if.then295, label %if.end296

if.then295:                                       ; preds = %if.end288
  store i8 0, i8* %correct, align 1
  br label %if.end296

if.end296:                                        ; preds = %if.then295, %if.end288
  %call297 = call i32 @seek(i32 noundef -26, i32 noundef 2)
  %call298 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %43 = load i8, i8* %buf, align 1
  %conv299 = zext i8 %43 to i32
  %or300 = or i32 %conv299, 112
  %cmp301 = icmp ne i32 %or300, 118
  br i1 %cmp301, label %if.then303, label %if.end304

if.then303:                                       ; preds = %if.end296
  store i8 0, i8* %correct, align 1
  br label %if.end304

if.end304:                                        ; preds = %if.then303, %if.end296
  %call305 = call i32 @seek(i32 noundef -24, i32 noundef 2)
  %call306 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %44 = load i8, i8* %buf, align 1
  %conv307 = zext i8 %44 to i32
  %cmp308 = icmp slt i32 %conv307, 26
  br i1 %cmp308, label %if.then310, label %if.end311

if.then310:                                       ; preds = %if.end304
  store i8 0, i8* %correct, align 1
  br label %if.end311

if.end311:                                        ; preds = %if.then310, %if.end304
  %call312 = call i32 @seek(i32 noundef 37, i32 noundef 0)
  %call313 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %45 = load i8, i8* %buf, align 1
  %conv314 = zext i8 %45 to i32
  %cmp315 = icmp sge i32 %conv314, 187
  br i1 %cmp315, label %if.then317, label %if.end318

if.then317:                                       ; preds = %if.end311
  store i8 0, i8* %correct, align 1
  br label %if.end318

if.end318:                                        ; preds = %if.then317, %if.end311
  %call319 = call i32 @seek(i32 noundef -2, i32 noundef 2)
  %call320 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %46 = load i8, i8* %buf, align 1
  %conv321 = zext i8 %46 to i32
  %or322 = or i32 %conv321, 34
  %cmp323 = icmp ne i32 %or322, 51
  br i1 %cmp323, label %if.then325, label %if.end326

if.then325:                                       ; preds = %if.end318
  store i8 0, i8* %correct, align 1
  br label %if.end326

if.end326:                                        ; preds = %if.then325, %if.end318
  %call327 = call i32 @seek(i32 noundef 23, i32 noundef 0)
  %call328 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %47 = load i8, i8* %buf, align 1
  %conv329 = zext i8 %47 to i32
  %cmp330 = icmp slt i32 %conv329, 59
  br i1 %cmp330, label %if.then332, label %if.end333

if.then332:                                       ; preds = %if.end326
  store i8 0, i8* %correct, align 1
  br label %if.end333

if.end333:                                        ; preds = %if.then332, %if.end326
  %call334 = call i32 @seek(i32 noundef -25, i32 noundef 2)
  %call335 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %48 = load i8, i8* %buf, align 1
  %conv336 = zext i8 %48 to i32
  %or337 = or i32 %conv336, 184
  %cmp338 = icmp ne i32 %or337, 255
  br i1 %cmp338, label %if.then340, label %if.end341

if.then340:                                       ; preds = %if.end333
  store i8 0, i8* %correct, align 1
  br label %if.end341

if.end341:                                        ; preds = %if.then340, %if.end333
  %call342 = call i32 @seek(i32 noundef 35, i32 noundef 0)
  %call343 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %49 = load i8, i8* %buf, align 1
  %conv344 = zext i8 %49 to i32
  %or345 = or i32 %conv344, 13
  %cmp346 = icmp ne i32 %or345, 95
  br i1 %cmp346, label %if.then348, label %if.end349

if.then348:                                       ; preds = %if.end341
  store i8 0, i8* %correct, align 1
  br label %if.end349

if.end349:                                        ; preds = %if.then348, %if.end341
  %call350 = call i32 @seek(i32 noundef 41, i32 noundef 0)
  %call351 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %50 = load i8, i8* %buf, align 1
  %conv352 = zext i8 %50 to i32
  %or353 = or i32 %conv352, 87
  %cmp354 = icmp ne i32 %or353, 119
  br i1 %cmp354, label %if.then356, label %if.end357

if.then356:                                       ; preds = %if.end349
  store i8 0, i8* %correct, align 1
  br label %if.end357

if.end357:                                        ; preds = %if.then356, %if.end349
  %call358 = call i32 @seek(i32 noundef 41, i32 noundef 0)
  %call359 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %51 = load i8, i8* %buf, align 1
  %conv360 = zext i8 %51 to i32
  %cmp361 = icmp sge i32 %conv360, 168
  br i1 %cmp361, label %if.then363, label %if.end364

if.then363:                                       ; preds = %if.end357
  store i8 0, i8* %correct, align 1
  br label %if.end364

if.end364:                                        ; preds = %if.then363, %if.end357
  %call365 = call i32 @seek(i32 noundef -14, i32 noundef 2)
  %call366 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %52 = load i8, i8* %buf, align 1
  %conv367 = zext i8 %52 to i32
  %or368 = or i32 %conv367, 173
  %cmp369 = icmp ne i32 %or368, 189
  br i1 %cmp369, label %if.then371, label %if.end372

if.then371:                                       ; preds = %if.end364
  store i8 0, i8* %correct, align 1
  br label %if.end372

if.end372:                                        ; preds = %if.then371, %if.end364
  %call373 = call i32 @seek(i32 noundef 6, i32 noundef 0)
  %call374 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %53 = load i8, i8* %buf, align 1
  %conv375 = zext i8 %53 to i32
  %or376 = or i32 %conv375, 252
  %cmp377 = icmp ne i32 %or376, 253
  br i1 %cmp377, label %if.then379, label %if.end380

if.then379:                                       ; preds = %if.end372
  store i8 0, i8* %correct, align 1
  br label %if.end380

if.end380:                                        ; preds = %if.then379, %if.end372
  %call381 = call i32 @seek(i32 noundef -15, i32 noundef 2)
  %call382 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %54 = load i8, i8* %buf, align 1
  %conv383 = zext i8 %54 to i32
  %cmp384 = icmp slt i32 %conv383, 27
  br i1 %cmp384, label %if.then386, label %if.end387

if.then386:                                       ; preds = %if.end380
  store i8 0, i8* %correct, align 1
  br label %if.end387

if.end387:                                        ; preds = %if.then386, %if.end380
  %call388 = call i32 @seek(i32 noundef -6, i32 noundef 2)
  %call389 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %55 = load i8, i8* %buf, align 1
  %conv390 = zext i8 %55 to i32
  %or391 = or i32 %conv390, 66
  %cmp392 = icmp ne i32 %or391, 110
  br i1 %cmp392, label %if.then394, label %if.end395

if.then394:                                       ; preds = %if.end387
  store i8 0, i8* %correct, align 1
  br label %if.end395

if.end395:                                        ; preds = %if.then394, %if.end387
  %call396 = call i32 @seek(i32 noundef -4, i32 noundef 2)
  %call397 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %56 = load i8, i8* %buf, align 1
  %conv398 = zext i8 %56 to i32
  %or399 = or i32 %conv398, 219
  %cmp400 = icmp ne i32 %or399, 251
  br i1 %cmp400, label %if.then402, label %if.end403

if.then402:                                       ; preds = %if.end395
  store i8 0, i8* %correct, align 1
  br label %if.end403

if.end403:                                        ; preds = %if.then402, %if.end395
  %call404 = call i32 @seek(i32 noundef 19, i32 noundef 0)
  %call405 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %57 = load i8, i8* %buf, align 1
  %conv406 = zext i8 %57 to i32
  %cmp407 = icmp sge i32 %conv406, 180
  br i1 %cmp407, label %if.then409, label %if.end410

if.then409:                                       ; preds = %if.end403
  store i8 0, i8* %correct, align 1
  br label %if.end410

if.end410:                                        ; preds = %if.then409, %if.end403
  %call411 = call i32 @seek(i32 noundef -29, i32 noundef 2)
  %call412 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %58 = load i8, i8* %buf, align 1
  %conv413 = zext i8 %58 to i32
  %and414 = and i32 %conv413, 233
  %cmp415 = icmp ne i32 %and414, 96
  br i1 %cmp415, label %if.then417, label %if.end418

if.then417:                                       ; preds = %if.end410
  store i8 0, i8* %correct, align 1
  br label %if.end418

if.end418:                                        ; preds = %if.then417, %if.end410
  %call419 = call i32 @seek(i32 noundef 37, i32 noundef 0)
  %call420 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %59 = load i8, i8* %buf, align 1
  %conv421 = zext i8 %59 to i32
  %or422 = or i32 %conv421, 121
  %cmp423 = icmp ne i32 %or422, 121
  br i1 %cmp423, label %if.then425, label %if.end426

if.then425:                                       ; preds = %if.end418
  store i8 0, i8* %correct, align 1
  br label %if.end426

if.end426:                                        ; preds = %if.then425, %if.end418
  %call427 = call i32 @seek(i32 noundef -21, i32 noundef 2)
  %call428 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %60 = load i8, i8* %buf, align 1
  %conv429 = zext i8 %60 to i32
  %cmp430 = icmp slt i32 %conv429, 94
  br i1 %cmp430, label %if.then432, label %if.end433

if.then432:                                       ; preds = %if.end426
  store i8 0, i8* %correct, align 1
  br label %if.end433

if.end433:                                        ; preds = %if.then432, %if.end426
  %call434 = call i32 @seek(i32 noundef 35, i32 noundef 0)
  %call435 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %61 = load i8, i8* %buf, align 1
  %conv436 = zext i8 %61 to i32
  %and437 = and i32 %conv436, 141
  %cmp438 = icmp ne i32 %and437, 13
  br i1 %cmp438, label %if.then440, label %if.end441

if.then440:                                       ; preds = %if.end433
  store i8 0, i8* %correct, align 1
  br label %if.end441

if.end441:                                        ; preds = %if.then440, %if.end433
  %call442 = call i32 @seek(i32 noundef -25, i32 noundef 2)
  %call443 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %62 = load i8, i8* %buf, align 1
  %conv444 = zext i8 %62 to i32
  %and445 = and i32 %conv444, 137
  %cmp446 = icmp ne i32 %and445, 9
  br i1 %cmp446, label %if.then448, label %if.end449

if.then448:                                       ; preds = %if.end441
  store i8 0, i8* %correct, align 1
  br label %if.end449

if.end449:                                        ; preds = %if.then448, %if.end441
  %call450 = call i32 @seek(i32 noundef 6, i32 noundef 0)
  %call451 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %63 = load i8, i8* %buf, align 1
  %conv452 = zext i8 %63 to i32
  %and453 = and i32 %conv452, 133
  %cmp454 = icmp ne i32 %and453, 5
  br i1 %cmp454, label %if.then456, label %if.end457

if.then456:                                       ; preds = %if.end449
  store i8 0, i8* %correct, align 1
  br label %if.end457

if.end457:                                        ; preds = %if.then456, %if.end449
  %call458 = call i32 @seek(i32 noundef -25, i32 noundef 2)
  %call459 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %64 = load i8, i8* %buf, align 1
  %conv460 = zext i8 %64 to i32
  %cmp461 = icmp slt i32 %conv460, 79
  br i1 %cmp461, label %if.then463, label %if.end464

if.then463:                                       ; preds = %if.end457
  store i8 0, i8* %correct, align 1
  br label %if.end464

if.end464:                                        ; preds = %if.then463, %if.end457
  %call465 = call i32 @seek(i32 noundef 8, i32 noundef 0)
  %call466 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %65 = load i8, i8* %buf, align 1
  %conv467 = zext i8 %65 to i32
  %cmp468 = icmp slt i32 %conv467, 9
  br i1 %cmp468, label %if.then470, label %if.end471

if.then470:                                       ; preds = %if.end464
  store i8 0, i8* %correct, align 1
  br label %if.end471

if.end471:                                        ; preds = %if.then470, %if.end464
  %call472 = call i32 @seek(i32 noundef -36, i32 noundef 2)
  %call473 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %66 = load i8, i8* %buf, align 1
  %conv474 = zext i8 %66 to i32
  %or475 = or i32 %conv474, 23
  %cmp476 = icmp ne i32 %or475, 119
  br i1 %cmp476, label %if.then478, label %if.end479

if.then478:                                       ; preds = %if.end471
  store i8 0, i8* %correct, align 1
  br label %if.end479

if.end479:                                        ; preds = %if.then478, %if.end471
  %call480 = call i32 @seek(i32 noundef 31, i32 noundef 0)
  %call481 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %67 = load i8, i8* %buf, align 1
  %conv482 = zext i8 %67 to i32
  %or483 = or i32 %conv482, 84
  %cmp484 = icmp ne i32 %or483, 116
  br i1 %cmp484, label %if.then486, label %if.end487

if.then486:                                       ; preds = %if.end479
  store i8 0, i8* %correct, align 1
  br label %if.end487

if.end487:                                        ; preds = %if.then486, %if.end479
  %call488 = call i32 @seek(i32 noundef 22, i32 noundef 0)
  %call489 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %68 = load i8, i8* %buf, align 1
  %conv490 = zext i8 %68 to i32
  %cmp491 = icmp slt i32 %conv490, 8
  br i1 %cmp491, label %if.then493, label %if.end494

if.then493:                                       ; preds = %if.end487
  store i8 0, i8* %correct, align 1
  br label %if.end494

if.end494:                                        ; preds = %if.then493, %if.end487
  %call495 = call i32 @seek(i32 noundef -25, i32 noundef 2)
  %call496 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %69 = load i8, i8* %buf, align 1
  %conv497 = zext i8 %69 to i32
  %and498 = and i32 %conv497, 241
  %cmp499 = icmp ne i32 %and498, 81
  br i1 %cmp499, label %if.then501, label %if.end502

if.then501:                                       ; preds = %if.end494
  store i8 0, i8* %correct, align 1
  br label %if.end502

if.end502:                                        ; preds = %if.then501, %if.end494
  %call503 = call i32 @seek(i32 noundef 29, i32 noundef 0)
  %call504 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %70 = load i8, i8* %buf, align 1
  %conv505 = zext i8 %70 to i32
  %cmp506 = icmp slt i32 %conv505, 57
  br i1 %cmp506, label %if.then508, label %if.end509

if.then508:                                       ; preds = %if.end502
  store i8 0, i8* %correct, align 1
  br label %if.end509

if.end509:                                        ; preds = %if.then508, %if.end502
  %call510 = call i32 @seek(i32 noundef 4, i32 noundef 0)
  %call511 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %71 = load i8, i8* %buf, align 1
  %conv512 = zext i8 %71 to i32
  %or513 = or i32 %conv512, 55
  %cmp514 = icmp ne i32 %or513, 127
  br i1 %cmp514, label %if.then516, label %if.end517

if.then516:                                       ; preds = %if.end509
  store i8 0, i8* %correct, align 1
  br label %if.end517

if.end517:                                        ; preds = %if.then516, %if.end509
  %call518 = call i32 @seek(i32 noundef -10, i32 noundef 2)
  %call519 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %72 = load i8, i8* %buf, align 1
  %conv520 = zext i8 %72 to i32
  %and521 = and i32 %conv520, 99
  %cmp522 = icmp ne i32 %and521, 99
  br i1 %cmp522, label %if.then524, label %if.end525

if.then524:                                       ; preds = %if.end517
  store i8 0, i8* %correct, align 1
  br label %if.end525

if.end525:                                        ; preds = %if.then524, %if.end517
  %call526 = call i32 @seek(i32 noundef -30, i32 noundef 2)
  %call527 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %73 = load i8, i8* %buf, align 1
  %conv528 = zext i8 %73 to i32
  %and529 = and i32 %conv528, 90
  %cmp530 = icmp ne i32 %and529, 74
  br i1 %cmp530, label %if.then532, label %if.end533

if.then532:                                       ; preds = %if.end525
  store i8 0, i8* %correct, align 1
  br label %if.end533

if.end533:                                        ; preds = %if.then532, %if.end525
  %call534 = call i32 @seek(i32 noundef 22, i32 noundef 0)
  %call535 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %74 = load i8, i8* %buf, align 1
  %conv536 = zext i8 %74 to i32
  %and537 = and i32 %conv536, 109
  %cmp538 = icmp ne i32 %and537, 32
  br i1 %cmp538, label %if.then540, label %if.end541

if.then540:                                       ; preds = %if.end533
  store i8 0, i8* %correct, align 1
  br label %if.end541

if.end541:                                        ; preds = %if.then540, %if.end533
  %call542 = call i32 @seek(i32 noundef 22, i32 noundef 0)
  %call543 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %75 = load i8, i8* %buf, align 1
  %conv544 = zext i8 %75 to i32
  %and545 = and i32 %conv544, 74
  %cmp546 = icmp ne i32 %and545, 0
  br i1 %cmp546, label %if.then548, label %if.end549

if.then548:                                       ; preds = %if.end541
  store i8 0, i8* %correct, align 1
  br label %if.end549

if.end549:                                        ; preds = %if.then548, %if.end541
  %call550 = call i32 @seek(i32 noundef -22, i32 noundef 2)
  %call551 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %76 = load i8, i8* %buf, align 1
  %conv552 = zext i8 %76 to i32
  %or553 = or i32 %conv552, 38
  %cmp554 = icmp ne i32 %or553, 54
  br i1 %cmp554, label %if.then556, label %if.end557

if.then556:                                       ; preds = %if.end549
  store i8 0, i8* %correct, align 1
  br label %if.end557

if.end557:                                        ; preds = %if.then556, %if.end549
  %call558 = call i32 @seek(i32 noundef 21, i32 noundef 0)
  %call559 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %77 = load i8, i8* %buf, align 1
  %conv560 = zext i8 %77 to i32
  %cmp561 = icmp sge i32 %conv560, 171
  br i1 %cmp561, label %if.then563, label %if.end564

if.then563:                                       ; preds = %if.end557
  store i8 0, i8* %correct, align 1
  br label %if.end564

if.end564:                                        ; preds = %if.then563, %if.end557
  %call565 = call i32 @seek(i32 noundef 23, i32 noundef 0)
  %call566 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %78 = load i8, i8* %buf, align 1
  %conv567 = zext i8 %78 to i32
  %or568 = or i32 %conv567, 159
  %cmp569 = icmp ne i32 %or568, 255
  br i1 %cmp569, label %if.then571, label %if.end572

if.then571:                                       ; preds = %if.end564
  store i8 0, i8* %correct, align 1
  br label %if.end572

if.end572:                                        ; preds = %if.then571, %if.end564
  %call573 = call i32 @seek(i32 noundef 7, i32 noundef 0)
  %call574 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %79 = load i8, i8* %buf, align 1
  %conv575 = zext i8 %79 to i32
  %cmp576 = icmp slt i32 %conv575, 1
  br i1 %cmp576, label %if.then578, label %if.end579

if.then578:                                       ; preds = %if.end572
  store i8 0, i8* %correct, align 1
  br label %if.end579

if.end579:                                        ; preds = %if.then578, %if.end572
  %call580 = call i32 @seek(i32 noundef 16, i32 noundef 0)
  %call581 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %80 = load i8, i8* %buf, align 1
  %conv582 = zext i8 %80 to i32
  %and583 = and i32 %conv582, 101
  %cmp584 = icmp ne i32 %and583, 69
  br i1 %cmp584, label %if.then586, label %if.end587

if.then586:                                       ; preds = %if.end579
  store i8 0, i8* %correct, align 1
  br label %if.end587

if.end587:                                        ; preds = %if.then586, %if.end579
  %call588 = call i32 @seek(i32 noundef 40, i32 noundef 0)
  %call589 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %81 = load i8, i8* %buf, align 1
  %conv590 = zext i8 %81 to i32
  %or591 = or i32 %conv590, 185
  %cmp592 = icmp ne i32 %or591, 249
  br i1 %cmp592, label %if.then594, label %if.end595

if.then594:                                       ; preds = %if.end587
  store i8 0, i8* %correct, align 1
  br label %if.end595

if.end595:                                        ; preds = %if.then594, %if.end587
  %call596 = call i32 @seek(i32 noundef 27, i32 noundef 0)
  %call597 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %82 = load i8, i8* %buf, align 1
  %conv598 = zext i8 %82 to i32
  %cmp599 = icmp slt i32 %conv598, 18
  br i1 %cmp599, label %if.then601, label %if.end602

if.then601:                                       ; preds = %if.end595
  store i8 0, i8* %correct, align 1
  br label %if.end602

if.end602:                                        ; preds = %if.then601, %if.end595
  %call603 = call i32 @seek(i32 noundef -22, i32 noundef 2)
  %call604 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %83 = load i8, i8* %buf, align 1
  %conv605 = zext i8 %83 to i32
  %or606 = or i32 %conv605, 60
  %cmp607 = icmp ne i32 %or606, 60
  br i1 %cmp607, label %if.then609, label %if.end610

if.then609:                                       ; preds = %if.end602
  store i8 0, i8* %correct, align 1
  br label %if.end610

if.end610:                                        ; preds = %if.then609, %if.end602
  %call611 = call i32 @seek(i32 noundef 35, i32 noundef 0)
  %call612 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %84 = load i8, i8* %buf, align 1
  %conv613 = zext i8 %84 to i32
  %cmp614 = icmp slt i32 %conv613, 10
  br i1 %cmp614, label %if.then616, label %if.end617

if.then616:                                       ; preds = %if.end610
  store i8 0, i8* %correct, align 1
  br label %if.end617

if.end617:                                        ; preds = %if.then616, %if.end610
  %call618 = call i32 @seek(i32 noundef 29, i32 noundef 0)
  %call619 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %85 = load i8, i8* %buf, align 1
  %conv620 = zext i8 %85 to i32
  %cmp621 = icmp sge i32 %conv620, 249
  br i1 %cmp621, label %if.then623, label %if.end624

if.then623:                                       ; preds = %if.end617
  store i8 0, i8* %correct, align 1
  br label %if.end624

if.end624:                                        ; preds = %if.then623, %if.end617
  %call625 = call i32 @seek(i32 noundef -16, i32 noundef 2)
  %call626 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %86 = load i8, i8* %buf, align 1
  %conv627 = zext i8 %86 to i32
  %and628 = and i32 %conv627, 93
  %cmp629 = icmp ne i32 %and628, 85
  br i1 %cmp629, label %if.then631, label %if.end632

if.then631:                                       ; preds = %if.end624
  store i8 0, i8* %correct, align 1
  br label %if.end632

if.end632:                                        ; preds = %if.then631, %if.end624
  %call633 = call i32 @seek(i32 noundef 39, i32 noundef 0)
  %call634 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %87 = load i8, i8* %buf, align 1
  %conv635 = zext i8 %87 to i32
  %and636 = and i32 %conv635, 202
  %cmp637 = icmp ne i32 %and636, 66
  br i1 %cmp637, label %if.then639, label %if.end640

if.then639:                                       ; preds = %if.end632
  store i8 0, i8* %correct, align 1
  br label %if.end640

if.end640:                                        ; preds = %if.then639, %if.end632
  %call641 = call i32 @seek(i32 noundef 37, i32 noundef 0)
  %call642 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %88 = load i8, i8* %buf, align 1
  %conv643 = zext i8 %88 to i32
  %and644 = and i32 %conv643, 242
  %cmp645 = icmp ne i32 %and644, 96
  br i1 %cmp645, label %if.then647, label %if.end648

if.then647:                                       ; preds = %if.end640
  store i8 0, i8* %correct, align 1
  br label %if.end648

if.end648:                                        ; preds = %if.then647, %if.end640
  %call649 = call i32 @seek(i32 noundef 26, i32 noundef 0)
  %call650 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %89 = load i8, i8* %buf, align 1
  %conv651 = zext i8 %89 to i32
  %cmp652 = icmp sge i32 %conv651, 178
  br i1 %cmp652, label %if.then654, label %if.end655

if.then654:                                       ; preds = %if.end648
  store i8 0, i8* %correct, align 1
  br label %if.end655

if.end655:                                        ; preds = %if.then654, %if.end648
  %call656 = call i32 @seek(i32 noundef -23, i32 noundef 2)
  %call657 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %90 = load i8, i8* %buf, align 1
  %conv658 = zext i8 %90 to i32
  %and659 = and i32 %conv658, 171
  %cmp660 = icmp ne i32 %and659, 32
  br i1 %cmp660, label %if.then662, label %if.end663

if.then662:                                       ; preds = %if.end655
  store i8 0, i8* %correct, align 1
  br label %if.end663

if.end663:                                        ; preds = %if.then662, %if.end655
  %call664 = call i32 @seek(i32 noundef 10, i32 noundef 0)
  %call665 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %91 = load i8, i8* %buf, align 1
  %conv666 = zext i8 %91 to i32
  %and667 = and i32 %conv666, 252
  %cmp668 = icmp ne i32 %and667, 48
  br i1 %cmp668, label %if.then670, label %if.end671

if.then670:                                       ; preds = %if.end663
  store i8 0, i8* %correct, align 1
  br label %if.end671

if.end671:                                        ; preds = %if.then670, %if.end663
  %call672 = call i32 @seek(i32 noundef 6, i32 noundef 0)
  %call673 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %92 = load i8, i8* %buf, align 1
  %conv674 = zext i8 %92 to i32
  %or675 = or i32 %conv674, 230
  %cmp676 = icmp ne i32 %or675, 247
  br i1 %cmp676, label %if.then678, label %if.end679

if.then678:                                       ; preds = %if.end671
  store i8 0, i8* %correct, align 1
  br label %if.end679

if.end679:                                        ; preds = %if.then678, %if.end671
  %call680 = call i32 @seek(i32 noundef -14, i32 noundef 2)
  %call681 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %93 = load i8, i8* %buf, align 1
  %conv682 = zext i8 %93 to i32
  %or683 = or i32 %conv682, 92
  %cmp684 = icmp ne i32 %or683, 125
  br i1 %cmp684, label %if.then686, label %if.end687

if.then686:                                       ; preds = %if.end679
  store i8 0, i8* %correct, align 1
  br label %if.end687

if.end687:                                        ; preds = %if.then686, %if.end679
  %call688 = call i32 @seek(i32 noundef -9, i32 noundef 2)
  %call689 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %94 = load i8, i8* %buf, align 1
  %conv690 = zext i8 %94 to i32
  %or691 = or i32 %conv690, 252
  %cmp692 = icmp ne i32 %or691, 255
  br i1 %cmp692, label %if.then694, label %if.end695

if.then694:                                       ; preds = %if.end687
  store i8 0, i8* %correct, align 1
  br label %if.end695

if.end695:                                        ; preds = %if.then694, %if.end687
  %call696 = call i32 @seek(i32 noundef -23, i32 noundef 2)
  %call697 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %95 = load i8, i8* %buf, align 1
  %conv698 = zext i8 %95 to i32
  %and699 = and i32 %conv698, 159
  %cmp700 = icmp ne i32 %and699, 16
  br i1 %cmp700, label %if.then702, label %if.end703

if.then702:                                       ; preds = %if.end695
  store i8 0, i8* %correct, align 1
  br label %if.end703

if.end703:                                        ; preds = %if.then702, %if.end695
  %call704 = call i32 @seek(i32 noundef 12, i32 noundef 0)
  %call705 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %96 = load i8, i8* %buf, align 1
  %conv706 = zext i8 %96 to i32
  %or707 = or i32 %conv706, 248
  %cmp708 = icmp ne i32 %or707, 251
  br i1 %cmp708, label %if.then710, label %if.end711

if.then710:                                       ; preds = %if.end703
  store i8 0, i8* %correct, align 1
  br label %if.end711

if.end711:                                        ; preds = %if.then710, %if.end703
  %call712 = call i32 @seek(i32 noundef -24, i32 noundef 2)
  %call713 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %97 = load i8, i8* %buf, align 1
  %conv714 = zext i8 %97 to i32
  %or715 = or i32 %conv714, 10
  %cmp716 = icmp ne i32 %or715, 111
  br i1 %cmp716, label %if.then718, label %if.end719

if.then718:                                       ; preds = %if.end711
  store i8 0, i8* %correct, align 1
  br label %if.end719

if.end719:                                        ; preds = %if.then718, %if.end711
  %call720 = call i32 @seek(i32 noundef 39, i32 noundef 0)
  %call721 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %98 = load i8, i8* %buf, align 1
  %conv722 = zext i8 %98 to i32
  %cmp723 = icmp sge i32 %conv722, 151
  br i1 %cmp723, label %if.then725, label %if.end726

if.then725:                                       ; preds = %if.end719
  store i8 0, i8* %correct, align 1
  br label %if.end726

if.end726:                                        ; preds = %if.then725, %if.end719
  %call727 = call i32 @seek(i32 noundef 41, i32 noundef 0)
  %call728 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %99 = load i8, i8* %buf, align 1
  %conv729 = zext i8 %99 to i32
  %or730 = or i32 %conv729, 30
  %cmp731 = icmp ne i32 %or730, 126
  br i1 %cmp731, label %if.then733, label %if.end734

if.then733:                                       ; preds = %if.end726
  store i8 0, i8* %correct, align 1
  br label %if.end734

if.end734:                                        ; preds = %if.then733, %if.end726
  %call735 = call i32 @seek(i32 noundef -17, i32 noundef 2)
  %call736 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %100 = load i8, i8* %buf, align 1
  %conv737 = zext i8 %100 to i32
  %cmp738 = icmp slt i32 %conv737, 20
  br i1 %cmp738, label %if.then740, label %if.end741

if.then740:                                       ; preds = %if.end734
  store i8 0, i8* %correct, align 1
  br label %if.end741

if.end741:                                        ; preds = %if.then740, %if.end734
  %call742 = call i32 @seek(i32 noundef -19, i32 noundef 2)
  %call743 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %101 = load i8, i8* %buf, align 1
  %conv744 = zext i8 %101 to i32
  %cmp745 = icmp sge i32 %conv744, 250
  br i1 %cmp745, label %if.then747, label %if.end748

if.then747:                                       ; preds = %if.end741
  store i8 0, i8* %correct, align 1
  br label %if.end748

if.end748:                                        ; preds = %if.then747, %if.end741
  %call749 = call i32 @seek(i32 noundef -29, i32 noundef 2)
  %call750 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %102 = load i8, i8* %buf, align 1
  %conv751 = zext i8 %102 to i32
  %or752 = or i32 %conv751, 160
  %cmp753 = icmp ne i32 %or752, 228
  br i1 %cmp753, label %if.then755, label %if.end756

if.then755:                                       ; preds = %if.end748
  store i8 0, i8* %correct, align 1
  br label %if.end756

if.end756:                                        ; preds = %if.then755, %if.end748
  %call757 = call i32 @seek(i32 noundef -20, i32 noundef 2)
  %call758 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %103 = load i8, i8* %buf, align 1
  %conv759 = zext i8 %103 to i32
  %and760 = and i32 %conv759, 13
  %cmp761 = icmp ne i32 %and760, 13
  br i1 %cmp761, label %if.then763, label %if.end764

if.then763:                                       ; preds = %if.end756
  store i8 0, i8* %correct, align 1
  br label %if.end764

if.end764:                                        ; preds = %if.then763, %if.end756
  %call765 = call i32 @seek(i32 noundef 13, i32 noundef 0)
  %call766 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %104 = load i8, i8* %buf, align 1
  %conv767 = zext i8 %104 to i32
  %and768 = and i32 %conv767, 238
  %cmp769 = icmp ne i32 %and768, 32
  br i1 %cmp769, label %if.then771, label %if.end772

if.then771:                                       ; preds = %if.end764
  store i8 0, i8* %correct, align 1
  br label %if.end772

if.end772:                                        ; preds = %if.then771, %if.end764
  %call773 = call i32 @seek(i32 noundef -26, i32 noundef 2)
  %call774 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %105 = load i8, i8* %buf, align 1
  %conv775 = zext i8 %105 to i32
  %and776 = and i32 %conv775, 21
  %cmp777 = icmp ne i32 %and776, 4
  br i1 %cmp777, label %if.then779, label %if.end780

if.then779:                                       ; preds = %if.end772
  store i8 0, i8* %correct, align 1
  br label %if.end780

if.end780:                                        ; preds = %if.then779, %if.end772
  %call781 = call i32 @seek(i32 noundef 31, i32 noundef 0)
  %call782 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %106 = load i8, i8* %buf, align 1
  %conv783 = zext i8 %106 to i32
  %cmp784 = icmp sge i32 %conv783, 192
  br i1 %cmp784, label %if.then786, label %if.end787

if.then786:                                       ; preds = %if.end780
  store i8 0, i8* %correct, align 1
  br label %if.end787

if.end787:                                        ; preds = %if.then786, %if.end780
  %call788 = call i32 @seek(i32 noundef 40, i32 noundef 0)
  %call789 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %107 = load i8, i8* %buf, align 1
  %conv790 = zext i8 %107 to i32
  %or791 = or i32 %conv790, 191
  %cmp792 = icmp ne i32 %or791, 255
  br i1 %cmp792, label %if.then794, label %if.end795

if.then794:                                       ; preds = %if.end787
  store i8 0, i8* %correct, align 1
  br label %if.end795

if.end795:                                        ; preds = %if.then794, %if.end787
  %call796 = call i32 @seek(i32 noundef -12, i32 noundef 2)
  %call797 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %108 = load i8, i8* %buf, align 1
  %conv798 = zext i8 %108 to i32
  %and799 = and i32 %conv798, 201
  %cmp800 = icmp ne i32 %and799, 1
  br i1 %cmp800, label %if.then802, label %if.end803

if.then802:                                       ; preds = %if.end795
  store i8 0, i8* %correct, align 1
  br label %if.end803

if.end803:                                        ; preds = %if.then802, %if.end795
  %call804 = call i32 @seek(i32 noundef -26, i32 noundef 2)
  %call805 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %109 = load i8, i8* %buf, align 1
  %conv806 = zext i8 %109 to i32
  %cmp807 = icmp sge i32 %conv806, 109
  br i1 %cmp807, label %if.then809, label %if.end810

if.then809:                                       ; preds = %if.end803
  store i8 0, i8* %correct, align 1
  br label %if.end810

if.end810:                                        ; preds = %if.then809, %if.end803
  %call811 = call i32 @seek(i32 noundef -4, i32 noundef 2)
  %call812 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %110 = load i8, i8* %buf, align 1
  %conv813 = zext i8 %110 to i32
  %cmp814 = icmp sge i32 %conv813, 99
  br i1 %cmp814, label %if.then816, label %if.end817

if.then816:                                       ; preds = %if.end810
  store i8 0, i8* %correct, align 1
  br label %if.end817

if.end817:                                        ; preds = %if.then816, %if.end810
  %call818 = call i32 @seek(i32 noundef 9, i32 noundef 0)
  %call819 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %111 = load i8, i8* %buf, align 1
  %conv820 = zext i8 %111 to i32
  %and821 = and i32 %conv820, 187
  %cmp822 = icmp ne i32 %and821, 50
  br i1 %cmp822, label %if.then824, label %if.end825

if.then824:                                       ; preds = %if.end817
  store i8 0, i8* %correct, align 1
  br label %if.end825

if.end825:                                        ; preds = %if.then824, %if.end817
  %call826 = call i32 @seek(i32 noundef 40, i32 noundef 0)
  %call827 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %112 = load i8, i8* %buf, align 1
  %conv828 = zext i8 %112 to i32
  %and829 = and i32 %conv828, 191
  %cmp830 = icmp ne i32 %and829, 33
  br i1 %cmp830, label %if.then832, label %if.end833

if.then832:                                       ; preds = %if.end825
  store i8 0, i8* %correct, align 1
  br label %if.end833

if.end833:                                        ; preds = %if.then832, %if.end825
  %call834 = call i32 @seek(i32 noundef -10, i32 noundef 2)
  %call835 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %113 = load i8, i8* %buf, align 1
  %conv836 = zext i8 %113 to i32
  %cmp837 = icmp sge i32 %conv836, 252
  br i1 %cmp837, label %if.then839, label %if.end840

if.then839:                                       ; preds = %if.end833
  store i8 0, i8* %correct, align 1
  br label %if.end840

if.end840:                                        ; preds = %if.then839, %if.end833
  %call841 = call i32 @seek(i32 noundef -20, i32 noundef 2)
  %call842 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %114 = load i8, i8* %buf, align 1
  %conv843 = zext i8 %114 to i32
  %cmp844 = icmp sge i32 %conv843, 176
  br i1 %cmp844, label %if.then846, label %if.end847

if.then846:                                       ; preds = %if.end840
  store i8 0, i8* %correct, align 1
  br label %if.end847

if.end847:                                        ; preds = %if.then846, %if.end840
  %call848 = call i32 @seek(i32 noundef -35, i32 noundef 2)
  %call849 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %115 = load i8, i8* %buf, align 1
  %conv850 = zext i8 %115 to i32
  %cmp851 = icmp slt i32 %conv850, 92
  br i1 %cmp851, label %if.then853, label %if.end854

if.then853:                                       ; preds = %if.end847
  store i8 0, i8* %correct, align 1
  br label %if.end854

if.end854:                                        ; preds = %if.then853, %if.end847
  %call855 = call i32 @seek(i32 noundef -29, i32 noundef 2)
  %call856 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %116 = load i8, i8* %buf, align 1
  %conv857 = zext i8 %116 to i32
  %cmp858 = icmp sge i32 %conv857, 187
  br i1 %cmp858, label %if.then860, label %if.end861

if.then860:                                       ; preds = %if.end854
  store i8 0, i8* %correct, align 1
  br label %if.end861

if.end861:                                        ; preds = %if.then860, %if.end854
  %call862 = call i32 @seek(i32 noundef -17, i32 noundef 2)
  %call863 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %117 = load i8, i8* %buf, align 1
  %conv864 = zext i8 %117 to i32
  %or865 = or i32 %conv864, 242
  %cmp866 = icmp ne i32 %or865, 255
  br i1 %cmp866, label %if.then868, label %if.end869

if.then868:                                       ; preds = %if.end861
  store i8 0, i8* %correct, align 1
  br label %if.end869

if.end869:                                        ; preds = %if.then868, %if.end861
  %call870 = call i32 @seek(i32 noundef 16, i32 noundef 0)
  %call871 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %118 = load i8, i8* %buf, align 1
  %conv872 = zext i8 %118 to i32
  %cmp873 = icmp sge i32 %conv872, 195
  br i1 %cmp873, label %if.then875, label %if.end876

if.then875:                                       ; preds = %if.end869
  store i8 0, i8* %correct, align 1
  br label %if.end876

if.end876:                                        ; preds = %if.then875, %if.end869
  %call877 = call i32 @seek(i32 noundef 16, i32 noundef 0)
  %call878 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %119 = load i8, i8* %buf, align 1
  %conv879 = zext i8 %119 to i32
  %and880 = and i32 %conv879, 42
  %cmp881 = icmp ne i32 %and880, 10
  br i1 %cmp881, label %if.then883, label %if.end884

if.then883:                                       ; preds = %if.end876
  store i8 0, i8* %correct, align 1
  br label %if.end884

if.end884:                                        ; preds = %if.then883, %if.end876
  %call885 = call i32 @seek(i32 noundef -34, i32 noundef 2)
  %call886 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %120 = load i8, i8* %buf, align 1
  %conv887 = zext i8 %120 to i32
  %or888 = or i32 %conv887, 78
  %cmp889 = icmp ne i32 %or888, 127
  br i1 %cmp889, label %if.then891, label %if.end892

if.then891:                                       ; preds = %if.end884
  store i8 0, i8* %correct, align 1
  br label %if.end892

if.end892:                                        ; preds = %if.then891, %if.end884
  %call893 = call i32 @seek(i32 noundef 23, i32 noundef 0)
  %call894 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %121 = load i8, i8* %buf, align 1
  %conv895 = zext i8 %121 to i32
  %cmp896 = icmp slt i32 %conv895, 48
  br i1 %cmp896, label %if.then898, label %if.end899

if.then898:                                       ; preds = %if.end892
  store i8 0, i8* %correct, align 1
  br label %if.end899

if.end899:                                        ; preds = %if.then898, %if.end892
  %call900 = call i32 @seek(i32 noundef 23, i32 noundef 0)
  %call901 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %122 = load i8, i8* %buf, align 1
  %conv902 = zext i8 %122 to i32
  %cmp903 = icmp sge i32 %conv902, 114
  br i1 %cmp903, label %if.then905, label %if.end906

if.then905:                                       ; preds = %if.end899
  store i8 0, i8* %correct, align 1
  br label %if.end906

if.end906:                                        ; preds = %if.then905, %if.end899
  %call907 = call i32 @seek(i32 noundef 22, i32 noundef 0)
  %call908 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %123 = load i8, i8* %buf, align 1
  %conv909 = zext i8 %123 to i32
  %or910 = or i32 %conv909, 111
  %cmp911 = icmp ne i32 %or910, 127
  br i1 %cmp911, label %if.then913, label %if.end914

if.then913:                                       ; preds = %if.end906
  store i8 0, i8* %correct, align 1
  br label %if.end914

if.end914:                                        ; preds = %if.then913, %if.end906
  %call915 = call i32 @seek(i32 noundef -36, i32 noundef 2)
  %call916 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %124 = load i8, i8* %buf, align 1
  %conv917 = zext i8 %124 to i32
  %cmp918 = icmp sge i32 %conv917, 218
  br i1 %cmp918, label %if.then920, label %if.end921

if.then920:                                       ; preds = %if.end914
  store i8 0, i8* %correct, align 1
  br label %if.end921

if.end921:                                        ; preds = %if.then920, %if.end914
  %call922 = call i32 @seek(i32 noundef 24, i32 noundef 0)
  %call923 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %125 = load i8, i8* %buf, align 1
  %conv924 = zext i8 %125 to i32
  %or925 = or i32 %conv924, 225
  %cmp926 = icmp ne i32 %or925, 255
  br i1 %cmp926, label %if.then928, label %if.end929

if.then928:                                       ; preds = %if.end921
  store i8 0, i8* %correct, align 1
  br label %if.end929

if.end929:                                        ; preds = %if.then928, %if.end921
  %call930 = call i32 @seek(i32 noundef -37, i32 noundef 2)
  %call931 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %126 = load i8, i8* %buf, align 1
  %conv932 = zext i8 %126 to i32
  %and933 = and i32 %conv932, 120
  %cmp934 = icmp ne i32 %and933, 88
  br i1 %cmp934, label %if.then936, label %if.end937

if.then936:                                       ; preds = %if.end929
  store i8 0, i8* %correct, align 1
  br label %if.end937

if.end937:                                        ; preds = %if.then936, %if.end929
  %call938 = call i32 @seek(i32 noundef -8, i32 noundef 2)
  %call939 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %127 = load i8, i8* %buf, align 1
  %conv940 = zext i8 %127 to i32
  %or941 = or i32 %conv940, 157
  %cmp942 = icmp ne i32 %or941, 253
  br i1 %cmp942, label %if.then944, label %if.end945

if.then944:                                       ; preds = %if.end937
  store i8 0, i8* %correct, align 1
  br label %if.end945

if.end945:                                        ; preds = %if.then944, %if.end937
  %call946 = call i32 @seek(i32 noundef -12, i32 noundef 2)
  %call947 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %128 = load i8, i8* %buf, align 1
  %conv948 = zext i8 %128 to i32
  %cmp949 = icmp slt i32 %conv948, 40
  br i1 %cmp949, label %if.then951, label %if.end952

if.then951:                                       ; preds = %if.end945
  store i8 0, i8* %correct, align 1
  br label %if.end952

if.end952:                                        ; preds = %if.then951, %if.end945
  %call953 = call i32 @seek(i32 noundef -36, i32 noundef 2)
  %call954 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %129 = load i8, i8* %buf, align 1
  %conv955 = zext i8 %129 to i32
  %cmp956 = icmp sge i32 %conv955, 103
  br i1 %cmp956, label %if.then958, label %if.end959

if.then958:                                       ; preds = %if.end952
  store i8 0, i8* %correct, align 1
  br label %if.end959

if.end959:                                        ; preds = %if.then958, %if.end952
  %call960 = call i32 @seek(i32 noundef 33, i32 noundef 0)
  %call961 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %130 = load i8, i8* %buf, align 1
  %conv962 = zext i8 %130 to i32
  %cmp963 = icmp sge i32 %conv962, 234
  br i1 %cmp963, label %if.then965, label %if.end966

if.then965:                                       ; preds = %if.end959
  store i8 0, i8* %correct, align 1
  br label %if.end966

if.end966:                                        ; preds = %if.then965, %if.end959
  %call967 = call i32 @seek(i32 noundef -33, i32 noundef 2)
  %call968 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %131 = load i8, i8* %buf, align 1
  %conv969 = zext i8 %131 to i32
  %and970 = and i32 %conv969, 98
  %cmp971 = icmp ne i32 %and970, 66
  br i1 %cmp971, label %if.then973, label %if.end974

if.then973:                                       ; preds = %if.end966
  store i8 0, i8* %correct, align 1
  br label %if.end974

if.end974:                                        ; preds = %if.then973, %if.end966
  %call975 = call i32 @seek(i32 noundef -29, i32 noundef 2)
  %call976 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %132 = load i8, i8* %buf, align 1
  %conv977 = zext i8 %132 to i32
  %cmp978 = icmp sge i32 %conv977, 108
  br i1 %cmp978, label %if.then980, label %if.end981

if.then980:                                       ; preds = %if.end974
  store i8 0, i8* %correct, align 1
  br label %if.end981

if.end981:                                        ; preds = %if.then980, %if.end974
  %call982 = call i32 @seek(i32 noundef -18, i32 noundef 2)
  %call983 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %133 = load i8, i8* %buf, align 1
  %conv984 = zext i8 %133 to i32
  %or985 = or i32 %conv984, 241
  %cmp986 = icmp ne i32 %or985, 245
  br i1 %cmp986, label %if.then988, label %if.end989

if.then988:                                       ; preds = %if.end981
  store i8 0, i8* %correct, align 1
  br label %if.end989

if.end989:                                        ; preds = %if.then988, %if.end981
  %call990 = call i32 @seek(i32 noundef -18, i32 noundef 2)
  %call991 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %134 = load i8, i8* %buf, align 1
  %conv992 = zext i8 %134 to i32
  %and993 = and i32 %conv992, 200
  %cmp994 = icmp ne i32 %and993, 64
  br i1 %cmp994, label %if.then996, label %if.end997

if.then996:                                       ; preds = %if.end989
  store i8 0, i8* %correct, align 1
  br label %if.end997

if.end997:                                        ; preds = %if.then996, %if.end989
  %call998 = call i32 @seek(i32 noundef 26, i32 noundef 0)
  %call999 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %135 = load i8, i8* %buf, align 1
  %conv1000 = zext i8 %135 to i32
  %cmp1001 = icmp sge i32 %conv1000, 172
  br i1 %cmp1001, label %if.then1003, label %if.end1004

if.then1003:                                      ; preds = %if.end997
  store i8 0, i8* %correct, align 1
  br label %if.end1004

if.end1004:                                       ; preds = %if.then1003, %if.end997
  %call1005 = call i32 @seek(i32 noundef 10, i32 noundef 0)
  %call1006 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %136 = load i8, i8* %buf, align 1
  %conv1007 = zext i8 %136 to i32
  %and1008 = and i32 %conv1007, 184
  %cmp1009 = icmp ne i32 %and1008, 48
  br i1 %cmp1009, label %if.then1011, label %if.end1012

if.then1011:                                      ; preds = %if.end1004
  store i8 0, i8* %correct, align 1
  br label %if.end1012

if.end1012:                                       ; preds = %if.then1011, %if.end1004
  %call1013 = call i32 @seek(i32 noundef 9, i32 noundef 0)
  %call1014 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %137 = load i8, i8* %buf, align 1
  %conv1015 = zext i8 %137 to i32
  %cmp1016 = icmp slt i32 %conv1015, 23
  br i1 %cmp1016, label %if.then1018, label %if.end1019

if.then1018:                                      ; preds = %if.end1012
  store i8 0, i8* %correct, align 1
  br label %if.end1019

if.end1019:                                       ; preds = %if.then1018, %if.end1012
  %call1020 = call i32 @seek(i32 noundef -37, i32 noundef 2)
  %call1021 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %138 = load i8, i8* %buf, align 1
  %conv1022 = zext i8 %138 to i32
  %cmp1023 = icmp slt i32 %conv1022, 30
  br i1 %cmp1023, label %if.then1025, label %if.end1026

if.then1025:                                      ; preds = %if.end1019
  store i8 0, i8* %correct, align 1
  br label %if.end1026

if.end1026:                                       ; preds = %if.then1025, %if.end1019
  %call1027 = call i32 @seek(i32 noundef -26, i32 noundef 2)
  %call1028 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %139 = load i8, i8* %buf, align 1
  %conv1029 = zext i8 %139 to i32
  %or1030 = or i32 %conv1029, 156
  %cmp1031 = icmp ne i32 %or1030, 254
  br i1 %cmp1031, label %if.then1033, label %if.end1034

if.then1033:                                      ; preds = %if.end1026
  store i8 0, i8* %correct, align 1
  br label %if.end1034

if.end1034:                                       ; preds = %if.then1033, %if.end1026
  %call1035 = call i32 @seek(i32 noundef 8, i32 noundef 0)
  %call1036 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %140 = load i8, i8* %buf, align 1
  %conv1037 = zext i8 %140 to i32
  %and1038 = and i32 %conv1037, 188
  %cmp1039 = icmp ne i32 %and1038, 32
  br i1 %cmp1039, label %if.then1041, label %if.end1042

if.then1041:                                      ; preds = %if.end1034
  store i8 0, i8* %correct, align 1
  br label %if.end1042

if.end1042:                                       ; preds = %if.then1041, %if.end1034
  %call1043 = call i32 @seek(i32 noundef -5, i32 noundef 2)
  %call1044 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %141 = load i8, i8* %buf, align 1
  %conv1045 = zext i8 %141 to i32
  %cmp1046 = icmp sge i32 %conv1045, 254
  br i1 %cmp1046, label %if.then1048, label %if.end1049

if.then1048:                                      ; preds = %if.end1042
  store i8 0, i8* %correct, align 1
  br label %if.end1049

if.end1049:                                       ; preds = %if.then1048, %if.end1042
  %call1050 = call i32 @seek(i32 noundef -11, i32 noundef 2)
  %call1051 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %142 = load i8, i8* %buf, align 1
  %conv1052 = zext i8 %142 to i32
  %cmp1053 = icmp slt i32 %conv1052, 40
  br i1 %cmp1053, label %if.then1055, label %if.end1056

if.then1055:                                      ; preds = %if.end1049
  store i8 0, i8* %correct, align 1
  br label %if.end1056

if.end1056:                                       ; preds = %if.then1055, %if.end1049
  %call1057 = call i32 @seek(i32 noundef 20, i32 noundef 0)
  %call1058 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %143 = load i8, i8* %buf, align 1
  %conv1059 = zext i8 %143 to i32
  %cmp1060 = icmp sge i32 %conv1059, 208
  br i1 %cmp1060, label %if.then1062, label %if.end1063

if.then1062:                                      ; preds = %if.end1056
  store i8 0, i8* %correct, align 1
  br label %if.end1063

if.end1063:                                       ; preds = %if.then1062, %if.end1056
  %call1064 = call i32 @seek(i32 noundef -22, i32 noundef 2)
  %call1065 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %144 = load i8, i8* %buf, align 1
  %conv1066 = zext i8 %144 to i32
  %cmp1067 = icmp sge i32 %conv1066, 135
  br i1 %cmp1067, label %if.then1069, label %if.end1070

if.then1069:                                      ; preds = %if.end1063
  store i8 0, i8* %correct, align 1
  br label %if.end1070

if.end1070:                                       ; preds = %if.then1069, %if.end1063
  %call1071 = call i32 @seek(i32 noundef -9, i32 noundef 2)
  %call1072 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %145 = load i8, i8* %buf, align 1
  %conv1073 = zext i8 %145 to i32
  %or1074 = or i32 %conv1073, 10
  %cmp1075 = icmp ne i32 %or1074, 95
  br i1 %cmp1075, label %if.then1077, label %if.end1078

if.then1077:                                      ; preds = %if.end1070
  store i8 0, i8* %correct, align 1
  br label %if.end1078

if.end1078:                                       ; preds = %if.then1077, %if.end1070
  %call1079 = call i32 @seek(i32 noundef -6, i32 noundef 2)
  %call1080 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %146 = load i8, i8* %buf, align 1
  %conv1081 = zext i8 %146 to i32
  %and1082 = and i32 %conv1081, 160
  %cmp1083 = icmp ne i32 %and1082, 32
  br i1 %cmp1083, label %if.then1085, label %if.end1086

if.then1085:                                      ; preds = %if.end1078
  store i8 0, i8* %correct, align 1
  br label %if.end1086

if.end1086:                                       ; preds = %if.then1085, %if.end1078
  %call1087 = call i32 @seek(i32 noundef -14, i32 noundef 2)
  %call1088 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %147 = load i8, i8* %buf, align 1
  %conv1089 = zext i8 %147 to i32
  %cmp1090 = icmp sge i32 %conv1089, 204
  br i1 %cmp1090, label %if.then1092, label %if.end1093

if.then1092:                                      ; preds = %if.end1086
  store i8 0, i8* %correct, align 1
  br label %if.end1093

if.end1093:                                       ; preds = %if.then1092, %if.end1086
  %call1094 = call i32 @seek(i32 noundef -12, i32 noundef 2)
  %call1095 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %148 = load i8, i8* %buf, align 1
  %conv1096 = zext i8 %148 to i32
  %cmp1097 = icmp sge i32 %conv1096, 63
  br i1 %cmp1097, label %if.then1099, label %if.end1100

if.then1099:                                      ; preds = %if.end1093
  store i8 0, i8* %correct, align 1
  br label %if.end1100

if.end1100:                                       ; preds = %if.then1099, %if.end1093
  %call1101 = call i32 @seek(i32 noundef 27, i32 noundef 0)
  %call1102 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %149 = load i8, i8* %buf, align 1
  %conv1103 = zext i8 %149 to i32
  %cmp1104 = icmp sge i32 %conv1103, 229
  br i1 %cmp1104, label %if.then1106, label %if.end1107

if.then1106:                                      ; preds = %if.end1100
  store i8 0, i8* %correct, align 1
  br label %if.end1107

if.end1107:                                       ; preds = %if.then1106, %if.end1100
  %call1108 = call i32 @seek(i32 noundef -15, i32 noundef 2)
  %call1109 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %150 = load i8, i8* %buf, align 1
  %conv1110 = zext i8 %150 to i32
  %or1111 = or i32 %conv1110, 4
  %cmp1112 = icmp ne i32 %or1111, 118
  br i1 %cmp1112, label %if.then1114, label %if.end1115

if.then1114:                                      ; preds = %if.end1107
  store i8 0, i8* %correct, align 1
  br label %if.end1115

if.end1115:                                       ; preds = %if.then1114, %if.end1107
  %call1116 = call i32 @seek(i32 noundef -3, i32 noundef 2)
  %call1117 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %151 = load i8, i8* %buf, align 1
  %conv1118 = zext i8 %151 to i32
  %and1119 = and i32 %conv1118, 43
  %cmp1120 = icmp ne i32 %and1119, 34
  br i1 %cmp1120, label %if.then1122, label %if.end1123

if.then1122:                                      ; preds = %if.end1115
  store i8 0, i8* %correct, align 1
  br label %if.end1123

if.end1123:                                       ; preds = %if.then1122, %if.end1115
  %call1124 = call i32 @seek(i32 noundef 11, i32 noundef 0)
  %call1125 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %152 = load i8, i8* %buf, align 1
  %conv1126 = zext i8 %152 to i32
  %cmp1127 = icmp sge i32 %conv1126, 116
  br i1 %cmp1127, label %if.then1129, label %if.end1130

if.then1129:                                      ; preds = %if.end1123
  store i8 0, i8* %correct, align 1
  br label %if.end1130

if.end1130:                                       ; preds = %if.then1129, %if.end1123
  %call1131 = call i32 @seek(i32 noundef -34, i32 noundef 2)
  %call1132 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %153 = load i8, i8* %buf, align 1
  %conv1133 = zext i8 %153 to i32
  %or1134 = or i32 %conv1133, 93
  %cmp1135 = icmp ne i32 %or1134, 127
  br i1 %cmp1135, label %if.then1137, label %if.end1138

if.then1137:                                      ; preds = %if.end1130
  store i8 0, i8* %correct, align 1
  br label %if.end1138

if.end1138:                                       ; preds = %if.then1137, %if.end1130
  %call1139 = call i32 @seek(i32 noundef -32, i32 noundef 2)
  %call1140 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %154 = load i8, i8* %buf, align 1
  %conv1141 = zext i8 %154 to i32
  %and1142 = and i32 %conv1141, 234
  %cmp1143 = icmp ne i32 %and1142, 106
  br i1 %cmp1143, label %if.then1145, label %if.end1146

if.then1145:                                      ; preds = %if.end1138
  store i8 0, i8* %correct, align 1
  br label %if.end1146

if.end1146:                                       ; preds = %if.then1145, %if.end1138
  %call1147 = call i32 @seek(i32 noundef 34, i32 noundef 0)
  %call1148 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %155 = load i8, i8* %buf, align 1
  %conv1149 = zext i8 %155 to i32
  %cmp1150 = icmp slt i32 %conv1149, 9
  br i1 %cmp1150, label %if.then1152, label %if.end1153

if.then1152:                                      ; preds = %if.end1146
  store i8 0, i8* %correct, align 1
  br label %if.end1153

if.end1153:                                       ; preds = %if.then1152, %if.end1146
  %call1154 = call i32 @seek(i32 noundef 39, i32 noundef 0)
  %call1155 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %156 = load i8, i8* %buf, align 1
  %conv1156 = zext i8 %156 to i32
  %cmp1157 = icmp slt i32 %conv1156, 36
  br i1 %cmp1157, label %if.then1159, label %if.end1160

if.then1159:                                      ; preds = %if.end1153
  store i8 0, i8* %correct, align 1
  br label %if.end1160

if.end1160:                                       ; preds = %if.then1159, %if.end1153
  %call1161 = call i32 @seek(i32 noundef 15, i32 noundef 0)
  %call1162 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %157 = load i8, i8* %buf, align 1
  %conv1163 = zext i8 %157 to i32
  %or1164 = or i32 %conv1163, 191
  %cmp1165 = icmp ne i32 %or1164, 255
  br i1 %cmp1165, label %if.then1167, label %if.end1168

if.then1167:                                      ; preds = %if.end1160
  store i8 0, i8* %correct, align 1
  br label %if.end1168

if.end1168:                                       ; preds = %if.then1167, %if.end1160
  %call1169 = call i32 @seek(i32 noundef 38, i32 noundef 0)
  %call1170 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %158 = load i8, i8* %buf, align 1
  %conv1171 = zext i8 %158 to i32
  %cmp1172 = icmp sge i32 %conv1171, 119
  br i1 %cmp1172, label %if.then1174, label %if.end1175

if.then1174:                                      ; preds = %if.end1168
  store i8 0, i8* %correct, align 1
  br label %if.end1175

if.end1175:                                       ; preds = %if.then1174, %if.end1168
  %call1176 = call i32 @seek(i32 noundef -12, i32 noundef 2)
  %call1177 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %159 = load i8, i8* %buf, align 1
  %conv1178 = zext i8 %159 to i32
  %cmp1179 = icmp sge i32 %conv1178, 216
  br i1 %cmp1179, label %if.then1181, label %if.end1182

if.then1181:                                      ; preds = %if.end1175
  store i8 0, i8* %correct, align 1
  br label %if.end1182

if.end1182:                                       ; preds = %if.then1181, %if.end1175
  %call1183 = call i32 @seek(i32 noundef -37, i32 noundef 2)
  %call1184 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %160 = load i8, i8* %buf, align 1
  %conv1185 = zext i8 %160 to i32
  %and1186 = and i32 %conv1185, 101
  %cmp1187 = icmp ne i32 %and1186, 69
  br i1 %cmp1187, label %if.then1189, label %if.end1190

if.then1189:                                      ; preds = %if.end1182
  store i8 0, i8* %correct, align 1
  br label %if.end1190

if.end1190:                                       ; preds = %if.then1189, %if.end1182
  %call1191 = call i32 @seek(i32 noundef 6, i32 noundef 0)
  %call1192 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %161 = load i8, i8* %buf, align 1
  %conv1193 = zext i8 %161 to i32
  %or1194 = or i32 %conv1193, 149
  %cmp1195 = icmp ne i32 %or1194, 245
  br i1 %cmp1195, label %if.then1197, label %if.end1198

if.then1197:                                      ; preds = %if.end1190
  store i8 0, i8* %correct, align 1
  br label %if.end1198

if.end1198:                                       ; preds = %if.then1197, %if.end1190
  %call1199 = call i32 @seek(i32 noundef 25, i32 noundef 0)
  %call1200 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %162 = load i8, i8* %buf, align 1
  %conv1201 = zext i8 %162 to i32
  %or1202 = or i32 %conv1201, 142
  %cmp1203 = icmp ne i32 %or1202, 239
  br i1 %cmp1203, label %if.then1205, label %if.end1206

if.then1205:                                      ; preds = %if.end1198
  store i8 0, i8* %correct, align 1
  br label %if.end1206

if.end1206:                                       ; preds = %if.then1205, %if.end1198
  %call1207 = call i32 @seek(i32 noundef 17, i32 noundef 0)
  %call1208 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %163 = load i8, i8* %buf, align 1
  %conv1209 = zext i8 %163 to i32
  %or1210 = or i32 %conv1209, 224
  %cmp1211 = icmp ne i32 %or1210, 240
  br i1 %cmp1211, label %if.then1213, label %if.end1214

if.then1213:                                      ; preds = %if.end1206
  store i8 0, i8* %correct, align 1
  br label %if.end1214

if.end1214:                                       ; preds = %if.then1213, %if.end1206
  %call1215 = call i32 @seek(i32 noundef -25, i32 noundef 2)
  %call1216 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %164 = load i8, i8* %buf, align 1
  %conv1217 = zext i8 %164 to i32
  %cmp1218 = icmp sge i32 %conv1217, 220
  br i1 %cmp1218, label %if.then1220, label %if.end1221

if.then1220:                                      ; preds = %if.end1214
  store i8 0, i8* %correct, align 1
  br label %if.end1221

if.end1221:                                       ; preds = %if.then1220, %if.end1214
  %call1222 = call i32 @seek(i32 noundef 17, i32 noundef 0)
  %call1223 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %165 = load i8, i8* %buf, align 1
  %conv1224 = zext i8 %165 to i32
  %and1225 = and i32 %conv1224, 128
  %cmp1226 = icmp ne i32 %and1225, 0
  br i1 %cmp1226, label %if.then1228, label %if.end1229

if.then1228:                                      ; preds = %if.end1221
  store i8 0, i8* %correct, align 1
  br label %if.end1229

if.end1229:                                       ; preds = %if.then1228, %if.end1221
  %call1230 = call i32 @seek(i32 noundef -23, i32 noundef 2)
  %call1231 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %166 = load i8, i8* %buf, align 1
  %conv1232 = zext i8 %166 to i32
  %cmp1233 = icmp sge i32 %conv1232, 58
  br i1 %cmp1233, label %if.then1235, label %if.end1236

if.then1235:                                      ; preds = %if.end1229
  store i8 0, i8* %correct, align 1
  br label %if.end1236

if.end1236:                                       ; preds = %if.then1235, %if.end1229
  %call1237 = call i32 @seek(i32 noundef 31, i32 noundef 0)
  %call1238 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %167 = load i8, i8* %buf, align 1
  %conv1239 = zext i8 %167 to i32
  %or1240 = or i32 %conv1239, 246
  %cmp1241 = icmp ne i32 %or1240, 246
  br i1 %cmp1241, label %if.then1243, label %if.end1244

if.then1243:                                      ; preds = %if.end1236
  store i8 0, i8* %correct, align 1
  br label %if.end1244

if.end1244:                                       ; preds = %if.then1243, %if.end1236
  %call1245 = call i32 @seek(i32 noundef 14, i32 noundef 0)
  %call1246 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %168 = load i8, i8* %buf, align 1
  %conv1247 = zext i8 %168 to i32
  %cmp1248 = icmp sge i32 %conv1247, 217
  br i1 %cmp1248, label %if.then1250, label %if.end1251

if.then1250:                                      ; preds = %if.end1244
  store i8 0, i8* %correct, align 1
  br label %if.end1251

if.end1251:                                       ; preds = %if.then1250, %if.end1244
  %call1252 = call i32 @seek(i32 noundef 14, i32 noundef 0)
  %call1253 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %169 = load i8, i8* %buf, align 1
  %conv1254 = zext i8 %169 to i32
  %cmp1255 = icmp slt i32 %conv1254, 105
  br i1 %cmp1255, label %if.then1257, label %if.end1258

if.then1257:                                      ; preds = %if.end1251
  store i8 0, i8* %correct, align 1
  br label %if.end1258

if.end1258:                                       ; preds = %if.then1257, %if.end1251
  %call1259 = call i32 @seek(i32 noundef -19, i32 noundef 2)
  %call1260 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %170 = load i8, i8* %buf, align 1
  %conv1261 = zext i8 %170 to i32
  %cmp1262 = icmp slt i32 %conv1261, 63
  br i1 %cmp1262, label %if.then1264, label %if.end1265

if.then1264:                                      ; preds = %if.end1258
  store i8 0, i8* %correct, align 1
  br label %if.end1265

if.end1265:                                       ; preds = %if.then1264, %if.end1258
  %call1266 = call i32 @seek(i32 noundef -27, i32 noundef 2)
  %call1267 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %171 = load i8, i8* %buf, align 1
  %conv1268 = zext i8 %171 to i32
  %or1269 = or i32 %conv1268, 207
  %cmp1270 = icmp ne i32 %or1269, 255
  br i1 %cmp1270, label %if.then1272, label %if.end1273

if.then1272:                                      ; preds = %if.end1265
  store i8 0, i8* %correct, align 1
  br label %if.end1273

if.end1273:                                       ; preds = %if.then1272, %if.end1265
  %call1274 = call i32 @seek(i32 noundef 39, i32 noundef 0)
  %call1275 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %172 = load i8, i8* %buf, align 1
  %conv1276 = zext i8 %172 to i32
  %or1277 = or i32 %conv1276, 207
  %cmp1278 = icmp ne i32 %or1277, 255
  br i1 %cmp1278, label %if.then1280, label %if.end1281

if.then1280:                                      ; preds = %if.end1273
  store i8 0, i8* %correct, align 1
  br label %if.end1281

if.end1281:                                       ; preds = %if.then1280, %if.end1273
  %call1282 = call i32 @seek(i32 noundef -32, i32 noundef 2)
  %call1283 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %173 = load i8, i8* %buf, align 1
  %conv1284 = zext i8 %173 to i32
  %and1285 = and i32 %conv1284, 5
  %cmp1286 = icmp ne i32 %and1285, 1
  br i1 %cmp1286, label %if.then1288, label %if.end1289

if.then1288:                                      ; preds = %if.end1281
  store i8 0, i8* %correct, align 1
  br label %if.end1289

if.end1289:                                       ; preds = %if.then1288, %if.end1281
  %call1290 = call i32 @seek(i32 noundef 9, i32 noundef 0)
  %call1291 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %174 = load i8, i8* %buf, align 1
  %conv1292 = zext i8 %174 to i32
  %cmp1293 = icmp sge i32 %conv1292, 218
  br i1 %cmp1293, label %if.then1295, label %if.end1296

if.then1295:                                      ; preds = %if.end1289
  store i8 0, i8* %correct, align 1
  br label %if.end1296

if.end1296:                                       ; preds = %if.then1295, %if.end1289
  %call1297 = call i32 @seek(i32 noundef 38, i32 noundef 0)
  %call1298 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %175 = load i8, i8* %buf, align 1
  %conv1299 = zext i8 %175 to i32
  %and1300 = and i32 %conv1299, 191
  %cmp1301 = icmp ne i32 %and1300, 44
  br i1 %cmp1301, label %if.then1303, label %if.end1304

if.then1303:                                      ; preds = %if.end1296
  store i8 0, i8* %correct, align 1
  br label %if.end1304

if.end1304:                                       ; preds = %if.then1303, %if.end1296
  %call1305 = call i32 @seek(i32 noundef 42, i32 noundef 0)
  %call1306 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %176 = load i8, i8* %buf, align 1
  %conv1307 = zext i8 %176 to i32
  %or1308 = or i32 %conv1307, 120
  %cmp1309 = icmp ne i32 %or1308, 123
  br i1 %cmp1309, label %if.then1311, label %if.end1312

if.then1311:                                      ; preds = %if.end1304
  store i8 0, i8* %correct, align 1
  br label %if.end1312

if.end1312:                                       ; preds = %if.then1311, %if.end1304
  %call1313 = call i32 @seek(i32 noundef 21, i32 noundef 0)
  %call1314 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %177 = load i8, i8* %buf, align 1
  %conv1315 = zext i8 %177 to i32
  %or1316 = or i32 %conv1315, 188
  %cmp1317 = icmp ne i32 %or1316, 188
  br i1 %cmp1317, label %if.then1319, label %if.end1320

if.then1319:                                      ; preds = %if.end1312
  store i8 0, i8* %correct, align 1
  br label %if.end1320

if.end1320:                                       ; preds = %if.then1319, %if.end1312
  %call1321 = call i32 @seek(i32 noundef -27, i32 noundef 2)
  %call1322 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %178 = load i8, i8* %buf, align 1
  %conv1323 = zext i8 %178 to i32
  %or1324 = or i32 %conv1323, 192
  %cmp1325 = icmp ne i32 %or1324, 240
  br i1 %cmp1325, label %if.then1327, label %if.end1328

if.then1327:                                      ; preds = %if.end1320
  store i8 0, i8* %correct, align 1
  br label %if.end1328

if.end1328:                                       ; preds = %if.then1327, %if.end1320
  %call1329 = call i32 @seek(i32 noundef -35, i32 noundef 2)
  %call1330 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %179 = load i8, i8* %buf, align 1
  %conv1331 = zext i8 %179 to i32
  %cmp1332 = icmp sge i32 %conv1331, 216
  br i1 %cmp1332, label %if.then1334, label %if.end1335

if.then1334:                                      ; preds = %if.end1328
  store i8 0, i8* %correct, align 1
  br label %if.end1335

if.end1335:                                       ; preds = %if.then1334, %if.end1328
  %call1336 = call i32 @seek(i32 noundef 14, i32 noundef 0)
  %call1337 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %180 = load i8, i8* %buf, align 1
  %conv1338 = zext i8 %180 to i32
  %or1339 = or i32 %conv1338, 161
  %cmp1340 = icmp ne i32 %or1339, 239
  br i1 %cmp1340, label %if.then1342, label %if.end1343

if.then1342:                                      ; preds = %if.end1335
  store i8 0, i8* %correct, align 1
  br label %if.end1343

if.end1343:                                       ; preds = %if.then1342, %if.end1335
  %call1344 = call i32 @seek(i32 noundef -7, i32 noundef 2)
  %call1345 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %181 = load i8, i8* %buf, align 1
  %conv1346 = zext i8 %181 to i32
  %or1347 = or i32 %conv1346, 48
  %cmp1348 = icmp ne i32 %or1347, 113
  br i1 %cmp1348, label %if.then1350, label %if.end1351

if.then1350:                                      ; preds = %if.end1343
  store i8 0, i8* %correct, align 1
  br label %if.end1351

if.end1351:                                       ; preds = %if.then1350, %if.end1343
  %call1352 = call i32 @seek(i32 noundef -4, i32 noundef 2)
  %call1353 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %182 = load i8, i8* %buf, align 1
  %conv1354 = zext i8 %182 to i32
  %or1355 = or i32 %conv1354, 111
  %cmp1356 = icmp ne i32 %or1355, 111
  br i1 %cmp1356, label %if.then1358, label %if.end1359

if.then1358:                                      ; preds = %if.end1351
  store i8 0, i8* %correct, align 1
  br label %if.end1359

if.end1359:                                       ; preds = %if.then1358, %if.end1351
  %call1360 = call i32 @seek(i32 noundef 42, i32 noundef 0)
  %call1361 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %183 = load i8, i8* %buf, align 1
  %conv1362 = zext i8 %183 to i32
  %and1363 = and i32 %conv1362, 30
  %cmp1364 = icmp ne i32 %and1363, 18
  br i1 %cmp1364, label %if.then1366, label %if.end1367

if.then1366:                                      ; preds = %if.end1359
  store i8 0, i8* %correct, align 1
  br label %if.end1367

if.end1367:                                       ; preds = %if.then1366, %if.end1359
  %call1368 = call i32 @seek(i32 noundef 16, i32 noundef 0)
  %call1369 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %184 = load i8, i8* %buf, align 1
  %conv1370 = zext i8 %184 to i32
  %cmp1371 = icmp sge i32 %conv1370, 130
  br i1 %cmp1371, label %if.then1373, label %if.end1374

if.then1373:                                      ; preds = %if.end1367
  store i8 0, i8* %correct, align 1
  br label %if.end1374

if.end1374:                                       ; preds = %if.then1373, %if.end1367
  %call1375 = call i32 @seek(i32 noundef 38, i32 noundef 0)
  %call1376 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %185 = load i8, i8* %buf, align 1
  %conv1377 = zext i8 %185 to i32
  %cmp1378 = icmp sge i32 %conv1377, 255
  br i1 %cmp1378, label %if.then1380, label %if.end1381

if.then1380:                                      ; preds = %if.end1374
  store i8 0, i8* %correct, align 1
  br label %if.end1381

if.end1381:                                       ; preds = %if.then1380, %if.end1374
  %call1382 = call i32 @seek(i32 noundef -39, i32 noundef 2)
  %call1383 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %186 = load i8, i8* %buf, align 1
  %conv1384 = zext i8 %186 to i32
  %cmp1385 = icmp sge i32 %conv1384, 59
  br i1 %cmp1385, label %if.then1387, label %if.end1388

if.then1387:                                      ; preds = %if.end1381
  store i8 0, i8* %correct, align 1
  br label %if.end1388

if.end1388:                                       ; preds = %if.then1387, %if.end1381
  %call1389 = call i32 @seek(i32 noundef 17, i32 noundef 0)
  %call1390 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %187 = load i8, i8* %buf, align 1
  %conv1391 = zext i8 %187 to i32
  %or1392 = or i32 %conv1391, 72
  %cmp1393 = icmp ne i32 %or1392, 120
  br i1 %cmp1393, label %if.then1395, label %if.end1396

if.then1395:                                      ; preds = %if.end1388
  store i8 0, i8* %correct, align 1
  br label %if.end1396

if.end1396:                                       ; preds = %if.then1395, %if.end1388
  %call1397 = call i32 @seek(i32 noundef 29, i32 noundef 0)
  %call1398 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %188 = load i8, i8* %buf, align 1
  %conv1399 = zext i8 %188 to i32
  %or1400 = or i32 %conv1399, 157
  %cmp1401 = icmp ne i32 %or1400, 255
  br i1 %cmp1401, label %if.then1403, label %if.end1404

if.then1403:                                      ; preds = %if.end1396
  store i8 0, i8* %correct, align 1
  br label %if.end1404

if.end1404:                                       ; preds = %if.then1403, %if.end1396
  %call1405 = call i32 @seek(i32 noundef 18, i32 noundef 0)
  %call1406 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %189 = load i8, i8* %buf, align 1
  %conv1407 = zext i8 %189 to i32
  %or1408 = or i32 %conv1407, 101
  %cmp1409 = icmp ne i32 %or1408, 103
  br i1 %cmp1409, label %if.then1411, label %if.end1412

if.then1411:                                      ; preds = %if.end1404
  store i8 0, i8* %correct, align 1
  br label %if.end1412

if.end1412:                                       ; preds = %if.then1411, %if.end1404
  %call1413 = call i32 @seek(i32 noundef -8, i32 noundef 2)
  %call1414 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %190 = load i8, i8* %buf, align 1
  %conv1415 = zext i8 %190 to i32
  %and1416 = and i32 %conv1415, 63
  %cmp1417 = icmp ne i32 %and1416, 45
  br i1 %cmp1417, label %if.then1419, label %if.end1420

if.then1419:                                      ; preds = %if.end1412
  store i8 0, i8* %correct, align 1
  br label %if.end1420

if.end1420:                                       ; preds = %if.then1419, %if.end1412
  %call1421 = call i32 @seek(i32 noundef 20, i32 noundef 0)
  %call1422 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %191 = load i8, i8* %buf, align 1
  %conv1423 = zext i8 %191 to i32
  %and1424 = and i32 %conv1423, 239
  %cmp1425 = icmp ne i32 %and1424, 103
  br i1 %cmp1425, label %if.then1427, label %if.end1428

if.then1427:                                      ; preds = %if.end1420
  store i8 0, i8* %correct, align 1
  br label %if.end1428

if.end1428:                                       ; preds = %if.then1427, %if.end1420
  %call1429 = call i32 @seek(i32 noundef -16, i32 noundef 2)
  %call1430 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %192 = load i8, i8* %buf, align 1
  %conv1431 = zext i8 %192 to i32
  %and1432 = and i32 %conv1431, 159
  %cmp1433 = icmp ne i32 %and1432, 23
  br i1 %cmp1433, label %if.then1435, label %if.end1436

if.then1435:                                      ; preds = %if.end1428
  store i8 0, i8* %correct, align 1
  br label %if.end1436

if.end1436:                                       ; preds = %if.then1435, %if.end1428
  %call1437 = call i32 @seek(i32 noundef -9, i32 noundef 2)
  %call1438 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %193 = load i8, i8* %buf, align 1
  %conv1439 = zext i8 %193 to i32
  %and1440 = and i32 %conv1439, 179
  %cmp1441 = icmp ne i32 %and1440, 19
  br i1 %cmp1441, label %if.then1443, label %if.end1444

if.then1443:                                      ; preds = %if.end1436
  store i8 0, i8* %correct, align 1
  br label %if.end1444

if.end1444:                                       ; preds = %if.then1443, %if.end1436
  %call1445 = call i32 @seek(i32 noundef -10, i32 noundef 2)
  %call1446 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %194 = load i8, i8* %buf, align 1
  %conv1447 = zext i8 %194 to i32
  %and1448 = and i32 %conv1447, 76
  %cmp1449 = icmp ne i32 %and1448, 68
  br i1 %cmp1449, label %if.then1451, label %if.end1452

if.then1451:                                      ; preds = %if.end1444
  store i8 0, i8* %correct, align 1
  br label %if.end1452

if.end1452:                                       ; preds = %if.then1451, %if.end1444
  %call1453 = call i32 @seek(i32 noundef 14, i32 noundef 0)
  %call1454 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %195 = load i8, i8* %buf, align 1
  %conv1455 = zext i8 %195 to i32
  %cmp1456 = icmp sge i32 %conv1455, 248
  br i1 %cmp1456, label %if.then1458, label %if.end1459

if.then1458:                                      ; preds = %if.end1452
  store i8 0, i8* %correct, align 1
  br label %if.end1459

if.end1459:                                       ; preds = %if.then1458, %if.end1452
  %call1460 = call i32 @seek(i32 noundef 14, i32 noundef 0)
  %call1461 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %196 = load i8, i8* %buf, align 1
  %conv1462 = zext i8 %196 to i32
  %cmp1463 = icmp sge i32 %conv1462, 233
  br i1 %cmp1463, label %if.then1465, label %if.end1466

if.then1465:                                      ; preds = %if.end1459
  store i8 0, i8* %correct, align 1
  br label %if.end1466

if.end1466:                                       ; preds = %if.then1465, %if.end1459
  %call1467 = call i32 @seek(i32 noundef 41, i32 noundef 0)
  %call1468 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %197 = load i8, i8* %buf, align 1
  %conv1469 = zext i8 %197 to i32
  %and1470 = and i32 %conv1469, 112
  %cmp1471 = icmp ne i32 %and1470, 112
  br i1 %cmp1471, label %if.then1473, label %if.end1474

if.then1473:                                      ; preds = %if.end1466
  store i8 0, i8* %correct, align 1
  br label %if.end1474

if.end1474:                                       ; preds = %if.then1473, %if.end1466
  %call1475 = call i32 @seek(i32 noundef 28, i32 noundef 0)
  %call1476 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %198 = load i8, i8* %buf, align 1
  %conv1477 = zext i8 %198 to i32
  %and1478 = and i32 %conv1477, 130
  %cmp1479 = icmp ne i32 %and1478, 2
  br i1 %cmp1479, label %if.then1481, label %if.end1482

if.then1481:                                      ; preds = %if.end1474
  store i8 0, i8* %correct, align 1
  br label %if.end1482

if.end1482:                                       ; preds = %if.then1481, %if.end1474
  %call1483 = call i32 @seek(i32 noundef 18, i32 noundef 0)
  %call1484 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %199 = load i8, i8* %buf, align 1
  %conv1485 = zext i8 %199 to i32
  %and1486 = and i32 %conv1485, 157
  %cmp1487 = icmp ne i32 %and1486, 4
  br i1 %cmp1487, label %if.then1489, label %if.end1490

if.then1489:                                      ; preds = %if.end1482
  store i8 0, i8* %correct, align 1
  br label %if.end1490

if.end1490:                                       ; preds = %if.then1489, %if.end1482
  %call1491 = call i32 @seek(i32 noundef -28, i32 noundef 2)
  %call1492 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %200 = load i8, i8* %buf, align 1
  %conv1493 = zext i8 %200 to i32
  %or1494 = or i32 %conv1493, 113
  %cmp1495 = icmp ne i32 %or1494, 127
  br i1 %cmp1495, label %if.then1497, label %if.end1498

if.then1497:                                      ; preds = %if.end1490
  store i8 0, i8* %correct, align 1
  br label %if.end1498

if.end1498:                                       ; preds = %if.then1497, %if.end1490
  %call1499 = call i32 @seek(i32 noundef -16, i32 noundef 2)
  %call1500 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %201 = load i8, i8* %buf, align 1
  %conv1501 = zext i8 %201 to i32
  %or1502 = or i32 %conv1501, 29
  %cmp1503 = icmp ne i32 %or1502, 127
  br i1 %cmp1503, label %if.then1505, label %if.end1506

if.then1505:                                      ; preds = %if.end1498
  store i8 0, i8* %correct, align 1
  br label %if.end1506

if.end1506:                                       ; preds = %if.then1505, %if.end1498
  %call1507 = call i32 @seek(i32 noundef -38, i32 noundef 2)
  %call1508 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %202 = load i8, i8* %buf, align 1
  %conv1509 = zext i8 %202 to i32
  %cmp1510 = icmp sge i32 %conv1509, 212
  br i1 %cmp1510, label %if.then1512, label %if.end1513

if.then1512:                                      ; preds = %if.end1506
  store i8 0, i8* %correct, align 1
  br label %if.end1513

if.end1513:                                       ; preds = %if.then1512, %if.end1506
  %call1514 = call i32 @seek(i32 noundef 12, i32 noundef 0)
  %call1515 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %203 = load i8, i8* %buf, align 1
  %conv1516 = zext i8 %203 to i32
  %or1517 = or i32 %conv1516, 53
  %cmp1518 = icmp ne i32 %or1517, 127
  br i1 %cmp1518, label %if.then1520, label %if.end1521

if.then1520:                                      ; preds = %if.end1513
  store i8 0, i8* %correct, align 1
  br label %if.end1521

if.end1521:                                       ; preds = %if.then1520, %if.end1513
  %call1522 = call i32 @seek(i32 noundef 23, i32 noundef 0)
  %call1523 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %204 = load i8, i8* %buf, align 1
  %conv1524 = zext i8 %204 to i32
  %and1525 = and i32 %conv1524, 6
  %cmp1526 = icmp ne i32 %and1525, 4
  br i1 %cmp1526, label %if.then1528, label %if.end1529

if.then1528:                                      ; preds = %if.end1521
  store i8 0, i8* %correct, align 1
  br label %if.end1529

if.end1529:                                       ; preds = %if.then1528, %if.end1521
  %call1530 = call i32 @seek(i32 noundef -12, i32 noundef 2)
  %call1531 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %205 = load i8, i8* %buf, align 1
  %conv1532 = zext i8 %205 to i32
  %and1533 = and i32 %conv1532, 87
  %cmp1534 = icmp ne i32 %and1533, 17
  br i1 %cmp1534, label %if.then1536, label %if.end1537

if.then1536:                                      ; preds = %if.end1529
  store i8 0, i8* %correct, align 1
  br label %if.end1537

if.end1537:                                       ; preds = %if.then1536, %if.end1529
  %call1538 = call i32 @seek(i32 noundef -17, i32 noundef 2)
  %call1539 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %206 = load i8, i8* %buf, align 1
  %conv1540 = zext i8 %206 to i32
  %and1541 = and i32 %conv1540, 123
  %cmp1542 = icmp ne i32 %and1541, 91
  br i1 %cmp1542, label %if.then1544, label %if.end1545

if.then1544:                                      ; preds = %if.end1537
  store i8 0, i8* %correct, align 1
  br label %if.end1545

if.end1545:                                       ; preds = %if.then1544, %if.end1537
  %call1546 = call i32 @seek(i32 noundef -31, i32 noundef 2)
  %call1547 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %207 = load i8, i8* %buf, align 1
  %conv1548 = zext i8 %207 to i32
  %and1549 = and i32 %conv1548, 60
  %cmp1550 = icmp ne i32 %and1549, 48
  br i1 %cmp1550, label %if.then1552, label %if.end1553

if.then1552:                                      ; preds = %if.end1545
  store i8 0, i8* %correct, align 1
  br label %if.end1553

if.end1553:                                       ; preds = %if.then1552, %if.end1545
  %call1554 = call i32 @seek(i32 noundef -23, i32 noundef 2)
  %call1555 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %208 = load i8, i8* %buf, align 1
  %conv1556 = zext i8 %208 to i32
  %and1557 = and i32 %conv1556, 49
  %cmp1558 = icmp ne i32 %and1557, 48
  br i1 %cmp1558, label %if.then1560, label %if.end1561

if.then1560:                                      ; preds = %if.end1553
  store i8 0, i8* %correct, align 1
  br label %if.end1561

if.end1561:                                       ; preds = %if.then1560, %if.end1553
  %call1562 = call i32 @seek(i32 noundef 21, i32 noundef 0)
  %call1563 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %209 = load i8, i8* %buf, align 1
  %conv1564 = zext i8 %209 to i32
  %or1565 = or i32 %conv1564, 215
  %cmp1566 = icmp ne i32 %or1565, 247
  br i1 %cmp1566, label %if.then1568, label %if.end1569

if.then1568:                                      ; preds = %if.end1561
  store i8 0, i8* %correct, align 1
  br label %if.end1569

if.end1569:                                       ; preds = %if.then1568, %if.end1561
  %call1570 = call i32 @seek(i32 noundef 42, i32 noundef 0)
  %call1571 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %210 = load i8, i8* %buf, align 1
  %conv1572 = zext i8 %210 to i32
  %and1573 = and i32 %conv1572, 18
  %cmp1574 = icmp ne i32 %and1573, 18
  br i1 %cmp1574, label %if.then1576, label %if.end1577

if.then1576:                                      ; preds = %if.end1569
  store i8 0, i8* %correct, align 1
  br label %if.end1577

if.end1577:                                       ; preds = %if.then1576, %if.end1569
  %call1578 = call i32 @seek(i32 noundef -33, i32 noundef 2)
  %call1579 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %211 = load i8, i8* %buf, align 1
  %conv1580 = zext i8 %211 to i32
  %cmp1581 = icmp slt i32 %conv1580, 87
  br i1 %cmp1581, label %if.then1583, label %if.end1584

if.then1583:                                      ; preds = %if.end1577
  store i8 0, i8* %correct, align 1
  br label %if.end1584

if.end1584:                                       ; preds = %if.then1583, %if.end1577
  %call1585 = call i32 @seek(i32 noundef -31, i32 noundef 2)
  %call1586 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %212 = load i8, i8* %buf, align 1
  %conv1587 = zext i8 %212 to i32
  %cmp1588 = icmp sge i32 %conv1587, 224
  br i1 %cmp1588, label %if.then1590, label %if.end1591

if.then1590:                                      ; preds = %if.end1584
  store i8 0, i8* %correct, align 1
  br label %if.end1591

if.end1591:                                       ; preds = %if.then1590, %if.end1584
  %call1592 = call i32 @seek(i32 noundef -5, i32 noundef 2)
  %call1593 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %213 = load i8, i8* %buf, align 1
  %conv1594 = zext i8 %213 to i32
  %and1595 = and i32 %conv1594, 221
  %cmp1596 = icmp ne i32 %and1595, 85
  br i1 %cmp1596, label %if.then1598, label %if.end1599

if.then1598:                                      ; preds = %if.end1591
  store i8 0, i8* %correct, align 1
  br label %if.end1599

if.end1599:                                       ; preds = %if.then1598, %if.end1591
  %call1600 = call i32 @seek(i32 noundef -39, i32 noundef 2)
  %call1601 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %214 = load i8, i8* %buf, align 1
  %conv1602 = zext i8 %214 to i32
  %cmp1603 = icmp sge i32 %conv1602, 155
  br i1 %cmp1603, label %if.then1605, label %if.end1606

if.then1605:                                      ; preds = %if.end1599
  store i8 0, i8* %correct, align 1
  br label %if.end1606

if.end1606:                                       ; preds = %if.then1605, %if.end1599
  %call1607 = call i32 @seek(i32 noundef -36, i32 noundef 2)
  %call1608 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %215 = load i8, i8* %buf, align 1
  %conv1609 = zext i8 %215 to i32
  %and1610 = and i32 %conv1609, 131
  %cmp1611 = icmp ne i32 %and1610, 1
  br i1 %cmp1611, label %if.then1613, label %if.end1614

if.then1613:                                      ; preds = %if.end1606
  store i8 0, i8* %correct, align 1
  br label %if.end1614

if.end1614:                                       ; preds = %if.then1613, %if.end1606
  %call1615 = call i32 @seek(i32 noundef -26, i32 noundef 2)
  %call1616 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %216 = load i8, i8* %buf, align 1
  %conv1617 = zext i8 %216 to i32
  %and1618 = and i32 %conv1617, 203
  %cmp1619 = icmp ne i32 %and1618, 66
  br i1 %cmp1619, label %if.then1621, label %if.end1622

if.then1621:                                      ; preds = %if.end1614
  store i8 0, i8* %correct, align 1
  br label %if.end1622

if.end1622:                                       ; preds = %if.then1621, %if.end1614
  %call1623 = call i32 @seek(i32 noundef 4, i32 noundef 0)
  %call1624 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %217 = load i8, i8* %buf, align 1
  %conv1625 = zext i8 %217 to i32
  %cmp1626 = icmp slt i32 %conv1625, 97
  br i1 %cmp1626, label %if.then1628, label %if.end1629

if.then1628:                                      ; preds = %if.end1622
  store i8 0, i8* %correct, align 1
  br label %if.end1629

if.end1629:                                       ; preds = %if.then1628, %if.end1622
  %call1630 = call i32 @seek(i32 noundef 36, i32 noundef 0)
  %call1631 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %218 = load i8, i8* %buf, align 1
  %conv1632 = zext i8 %218 to i32
  %or1633 = or i32 %conv1632, 111
  %cmp1634 = icmp ne i32 %or1633, 111
  br i1 %cmp1634, label %if.then1636, label %if.end1637

if.then1636:                                      ; preds = %if.end1629
  store i8 0, i8* %correct, align 1
  br label %if.end1637

if.end1637:                                       ; preds = %if.then1636, %if.end1629
  %call1638 = call i32 @seek(i32 noundef 40, i32 noundef 0)
  %call1639 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %219 = load i8, i8* %buf, align 1
  %conv1640 = zext i8 %219 to i32
  %or1641 = or i32 %conv1640, 71
  %cmp1642 = icmp ne i32 %or1641, 103
  br i1 %cmp1642, label %if.then1644, label %if.end1645

if.then1644:                                      ; preds = %if.end1637
  store i8 0, i8* %correct, align 1
  br label %if.end1645

if.end1645:                                       ; preds = %if.then1644, %if.end1637
  %call1646 = call i32 @seek(i32 noundef -7, i32 noundef 2)
  %call1647 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %220 = load i8, i8* %buf, align 1
  %conv1648 = zext i8 %220 to i32
  %and1649 = and i32 %conv1648, 22
  %cmp1650 = icmp ne i32 %and1649, 0
  br i1 %cmp1650, label %if.then1652, label %if.end1653

if.then1652:                                      ; preds = %if.end1645
  store i8 0, i8* %correct, align 1
  br label %if.end1653

if.end1653:                                       ; preds = %if.then1652, %if.end1645
  %call1654 = call i32 @seek(i32 noundef -11, i32 noundef 2)
  %call1655 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %221 = load i8, i8* %buf, align 1
  %conv1656 = zext i8 %221 to i32
  %or1657 = or i32 %conv1656, 82
  %cmp1658 = icmp ne i32 %or1657, 126
  br i1 %cmp1658, label %if.then1660, label %if.end1661

if.then1660:                                      ; preds = %if.end1653
  store i8 0, i8* %correct, align 1
  br label %if.end1661

if.end1661:                                       ; preds = %if.then1660, %if.end1653
  %call1662 = call i32 @seek(i32 noundef 20, i32 noundef 0)
  %call1663 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %222 = load i8, i8* %buf, align 1
  %conv1664 = zext i8 %222 to i32
  %cmp1665 = icmp sge i32 %conv1664, 227
  br i1 %cmp1665, label %if.then1667, label %if.end1668

if.then1667:                                      ; preds = %if.end1661
  store i8 0, i8* %correct, align 1
  br label %if.end1668

if.end1668:                                       ; preds = %if.then1667, %if.end1661
  %call1669 = call i32 @seek(i32 noundef -12, i32 noundef 2)
  %call1670 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %223 = load i8, i8* %buf, align 1
  %conv1671 = zext i8 %223 to i32
  %cmp1672 = icmp sge i32 %conv1671, 166
  br i1 %cmp1672, label %if.then1674, label %if.end1675

if.then1674:                                      ; preds = %if.end1668
  store i8 0, i8* %correct, align 1
  br label %if.end1675

if.end1675:                                       ; preds = %if.then1674, %if.end1668
  %call1676 = call i32 @seek(i32 noundef 28, i32 noundef 0)
  %call1677 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %224 = load i8, i8* %buf, align 1
  %conv1678 = zext i8 %224 to i32
  %or1679 = or i32 %conv1678, 73
  %cmp1680 = icmp ne i32 %or1679, 127
  br i1 %cmp1680, label %if.then1682, label %if.end1683

if.then1682:                                      ; preds = %if.end1675
  store i8 0, i8* %correct, align 1
  br label %if.end1683

if.end1683:                                       ; preds = %if.then1682, %if.end1675
  %call1684 = call i32 @seek(i32 noundef -7, i32 noundef 2)
  %call1685 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %225 = load i8, i8* %buf, align 1
  %conv1686 = zext i8 %225 to i32
  %and1687 = and i32 %conv1686, 19
  %cmp1688 = icmp ne i32 %and1687, 1
  br i1 %cmp1688, label %if.then1690, label %if.end1691

if.then1690:                                      ; preds = %if.end1683
  store i8 0, i8* %correct, align 1
  br label %if.end1691

if.end1691:                                       ; preds = %if.then1690, %if.end1683
  %call1692 = call i32 @seek(i32 noundef -17, i32 noundef 2)
  %call1693 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %226 = load i8, i8* %buf, align 1
  %conv1694 = zext i8 %226 to i32
  %and1695 = and i32 %conv1694, 179
  %cmp1696 = icmp ne i32 %and1695, 19
  br i1 %cmp1696, label %if.then1698, label %if.end1699

if.then1698:                                      ; preds = %if.end1691
  store i8 0, i8* %correct, align 1
  br label %if.end1699

if.end1699:                                       ; preds = %if.then1698, %if.end1691
  %call1700 = call i32 @seek(i32 noundef -32, i32 noundef 2)
  %call1701 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %227 = load i8, i8* %buf, align 1
  %conv1702 = zext i8 %227 to i32
  %and1703 = and i32 %conv1702, 99
  %cmp1704 = icmp ne i32 %and1703, 99
  br i1 %cmp1704, label %if.then1706, label %if.end1707

if.then1706:                                      ; preds = %if.end1699
  store i8 0, i8* %correct, align 1
  br label %if.end1707

if.end1707:                                       ; preds = %if.then1706, %if.end1699
  %call1708 = call i32 @seek(i32 noundef -35, i32 noundef 2)
  %call1709 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %228 = load i8, i8* %buf, align 1
  %conv1710 = zext i8 %228 to i32
  %or1711 = or i32 %conv1710, 196
  %cmp1712 = icmp ne i32 %or1711, 246
  br i1 %cmp1712, label %if.then1714, label %if.end1715

if.then1714:                                      ; preds = %if.end1707
  store i8 0, i8* %correct, align 1
  br label %if.end1715

if.end1715:                                       ; preds = %if.then1714, %if.end1707
  %call1716 = call i32 @seek(i32 noundef -19, i32 noundef 2)
  %call1717 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %229 = load i8, i8* %buf, align 1
  %conv1718 = zext i8 %229 to i32
  %and1719 = and i32 %conv1718, 162
  %cmp1720 = icmp ne i32 %and1719, 32
  br i1 %cmp1720, label %if.then1722, label %if.end1723

if.then1722:                                      ; preds = %if.end1715
  store i8 0, i8* %correct, align 1
  br label %if.end1723

if.end1723:                                       ; preds = %if.then1722, %if.end1715
  %call1724 = call i32 @seek(i32 noundef 31, i32 noundef 0)
  %call1725 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %230 = load i8, i8* %buf, align 1
  %conv1726 = zext i8 %230 to i32
  %cmp1727 = icmp slt i32 %conv1726, 48
  br i1 %cmp1727, label %if.then1729, label %if.end1730

if.then1729:                                      ; preds = %if.end1723
  store i8 0, i8* %correct, align 1
  br label %if.end1730

if.end1730:                                       ; preds = %if.then1729, %if.end1723
  %call1731 = call i32 @seek(i32 noundef -13, i32 noundef 2)
  %call1732 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %231 = load i8, i8* %buf, align 1
  %conv1733 = zext i8 %231 to i32
  %cmp1734 = icmp sge i32 %conv1733, 123
  br i1 %cmp1734, label %if.then1736, label %if.end1737

if.then1736:                                      ; preds = %if.end1730
  store i8 0, i8* %correct, align 1
  br label %if.end1737

if.end1737:                                       ; preds = %if.then1736, %if.end1730
  %call1738 = call i32 @seek(i32 noundef 36, i32 noundef 0)
  %call1739 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %232 = load i8, i8* %buf, align 1
  %conv1740 = zext i8 %232 to i32
  %cmp1741 = icmp slt i32 %conv1740, 1
  br i1 %cmp1741, label %if.then1743, label %if.end1744

if.then1743:                                      ; preds = %if.end1737
  store i8 0, i8* %correct, align 1
  br label %if.end1744

if.end1744:                                       ; preds = %if.then1743, %if.end1737
  %call1745 = call i32 @seek(i32 noundef -40, i32 noundef 2)
  %call1746 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %233 = load i8, i8* %buf, align 1
  %conv1747 = zext i8 %233 to i32
  %or1748 = or i32 %conv1747, 96
  %cmp1749 = icmp ne i32 %or1748, 121
  br i1 %cmp1749, label %if.then1751, label %if.end1752

if.then1751:                                      ; preds = %if.end1744
  store i8 0, i8* %correct, align 1
  br label %if.end1752

if.end1752:                                       ; preds = %if.then1751, %if.end1744
  %call1753 = call i32 @seek(i32 noundef -40, i32 noundef 2)
  %call1754 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %234 = load i8, i8* %buf, align 1
  %conv1755 = zext i8 %234 to i32
  %and1756 = and i32 %conv1755, 225
  %cmp1757 = icmp ne i32 %and1756, 97
  br i1 %cmp1757, label %if.then1759, label %if.end1760

if.then1759:                                      ; preds = %if.end1752
  store i8 0, i8* %correct, align 1
  br label %if.end1760

if.end1760:                                       ; preds = %if.then1759, %if.end1752
  %call1761 = call i32 @seek(i32 noundef 24, i32 noundef 0)
  %call1762 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %235 = load i8, i8* %buf, align 1
  %conv1763 = zext i8 %235 to i32
  %or1764 = or i32 %conv1763, 53
  %cmp1765 = icmp ne i32 %or1764, 127
  br i1 %cmp1765, label %if.then1767, label %if.end1768

if.then1767:                                      ; preds = %if.end1760
  store i8 0, i8* %correct, align 1
  br label %if.end1768

if.end1768:                                       ; preds = %if.then1767, %if.end1760
  %call1769 = call i32 @seek(i32 noundef 34, i32 noundef 0)
  %call1770 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %236 = load i8, i8* %buf, align 1
  %conv1771 = zext i8 %236 to i32
  %cmp1772 = icmp sge i32 %conv1771, 253
  br i1 %cmp1772, label %if.then1774, label %if.end1775

if.then1774:                                      ; preds = %if.end1768
  store i8 0, i8* %correct, align 1
  br label %if.end1775

if.end1775:                                       ; preds = %if.then1774, %if.end1768
  %call1776 = call i32 @seek(i32 noundef 17, i32 noundef 0)
  %call1777 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %237 = load i8, i8* %buf, align 1
  %conv1778 = zext i8 %237 to i32
  %cmp1779 = icmp sge i32 %conv1778, 91
  br i1 %cmp1779, label %if.then1781, label %if.end1782

if.then1781:                                      ; preds = %if.end1775
  store i8 0, i8* %correct, align 1
  br label %if.end1782

if.end1782:                                       ; preds = %if.then1781, %if.end1775
  %call1783 = call i32 @seek(i32 noundef 40, i32 noundef 0)
  %call1784 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %238 = load i8, i8* %buf, align 1
  %conv1785 = zext i8 %238 to i32
  %cmp1786 = icmp sge i32 %conv1785, 215
  br i1 %cmp1786, label %if.then1788, label %if.end1789

if.then1788:                                      ; preds = %if.end1782
  store i8 0, i8* %correct, align 1
  br label %if.end1789

if.end1789:                                       ; preds = %if.then1788, %if.end1782
  %call1790 = call i32 @seek(i32 noundef 7, i32 noundef 0)
  %call1791 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %239 = load i8, i8* %buf, align 1
  %conv1792 = zext i8 %239 to i32
  %or1793 = or i32 %conv1792, 110
  %cmp1794 = icmp ne i32 %or1793, 127
  br i1 %cmp1794, label %if.then1796, label %if.end1797

if.then1796:                                      ; preds = %if.end1789
  store i8 0, i8* %correct, align 1
  br label %if.end1797

if.end1797:                                       ; preds = %if.then1796, %if.end1789
  %call1798 = call i32 @seek(i32 noundef 25, i32 noundef 0)
  %call1799 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %240 = load i8, i8* %buf, align 1
  %conv1800 = zext i8 %240 to i32
  %and1801 = and i32 %conv1800, 73
  %cmp1802 = icmp ne i32 %and1801, 65
  br i1 %cmp1802, label %if.then1804, label %if.end1805

if.then1804:                                      ; preds = %if.end1797
  store i8 0, i8* %correct, align 1
  br label %if.end1805

if.end1805:                                       ; preds = %if.then1804, %if.end1797
  %call1806 = call i32 @seek(i32 noundef -11, i32 noundef 2)
  %call1807 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %241 = load i8, i8* %buf, align 1
  %conv1808 = zext i8 %241 to i32
  %or1809 = or i32 %conv1808, 227
  %cmp1810 = icmp ne i32 %or1809, 239
  br i1 %cmp1810, label %if.then1812, label %if.end1813

if.then1812:                                      ; preds = %if.end1805
  store i8 0, i8* %correct, align 1
  br label %if.end1813

if.end1813:                                       ; preds = %if.then1812, %if.end1805
  %call1814 = call i32 @seek(i32 noundef -37, i32 noundef 2)
  %call1815 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %242 = load i8, i8* %buf, align 1
  %conv1816 = zext i8 %242 to i32
  %and1817 = and i32 %conv1816, 37
  %cmp1818 = icmp ne i32 %and1817, 5
  br i1 %cmp1818, label %if.then1820, label %if.end1821

if.then1820:                                      ; preds = %if.end1813
  store i8 0, i8* %correct, align 1
  br label %if.end1821

if.end1821:                                       ; preds = %if.then1820, %if.end1813
  %call1822 = call i32 @seek(i32 noundef -7, i32 noundef 2)
  %call1823 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %243 = load i8, i8* %buf, align 1
  %conv1824 = zext i8 %243 to i32
  %or1825 = or i32 %conv1824, 102
  %cmp1826 = icmp ne i32 %or1825, 103
  br i1 %cmp1826, label %if.then1828, label %if.end1829

if.then1828:                                      ; preds = %if.end1821
  store i8 0, i8* %correct, align 1
  br label %if.end1829

if.end1829:                                       ; preds = %if.then1828, %if.end1821
  %call1830 = call i32 @seek(i32 noundef 11, i32 noundef 0)
  %call1831 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %244 = load i8, i8* %buf, align 1
  %conv1832 = zext i8 %244 to i32
  %and1833 = and i32 %conv1832, 242
  %cmp1834 = icmp ne i32 %and1833, 82
  br i1 %cmp1834, label %if.then1836, label %if.end1837

if.then1836:                                      ; preds = %if.end1829
  store i8 0, i8* %correct, align 1
  br label %if.end1837

if.end1837:                                       ; preds = %if.then1836, %if.end1829
  %call1838 = call i32 @seek(i32 noundef -6, i32 noundef 2)
  %call1839 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %245 = load i8, i8* %buf, align 1
  %conv1840 = zext i8 %245 to i32
  %and1841 = and i32 %conv1840, 160
  %cmp1842 = icmp ne i32 %and1841, 32
  br i1 %cmp1842, label %if.then1844, label %if.end1845

if.then1844:                                      ; preds = %if.end1837
  store i8 0, i8* %correct, align 1
  br label %if.end1845

if.end1845:                                       ; preds = %if.then1844, %if.end1837
  %call1846 = call i32 @seek(i32 noundef -10, i32 noundef 2)
  %call1847 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %246 = load i8, i8* %buf, align 1
  %conv1848 = zext i8 %246 to i32
  %or1849 = or i32 %conv1848, 180
  %cmp1850 = icmp ne i32 %or1849, 247
  br i1 %cmp1850, label %if.then1852, label %if.end1853

if.then1852:                                      ; preds = %if.end1845
  store i8 0, i8* %correct, align 1
  br label %if.end1853

if.end1853:                                       ; preds = %if.then1852, %if.end1845
  %call1854 = call i32 @seek(i32 noundef -28, i32 noundef 2)
  %call1855 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %247 = load i8, i8* %buf, align 1
  %conv1856 = zext i8 %247 to i32
  %cmp1857 = icmp slt i32 %conv1856, 54
  br i1 %cmp1857, label %if.then1859, label %if.end1860

if.then1859:                                      ; preds = %if.end1853
  store i8 0, i8* %correct, align 1
  br label %if.end1860

if.end1860:                                       ; preds = %if.then1859, %if.end1853
  %call1861 = call i32 @seek(i32 noundef 8, i32 noundef 0)
  %call1862 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %248 = load i8, i8* %buf, align 1
  %conv1863 = zext i8 %248 to i32
  %or1864 = or i32 %conv1863, 83
  %cmp1865 = icmp ne i32 %or1864, 115
  br i1 %cmp1865, label %if.then1867, label %if.end1868

if.then1867:                                      ; preds = %if.end1860
  store i8 0, i8* %correct, align 1
  br label %if.end1868

if.end1868:                                       ; preds = %if.then1867, %if.end1860
  %call1869 = call i32 @seek(i32 noundef 42, i32 noundef 0)
  %call1870 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %249 = load i8, i8* %buf, align 1
  %conv1871 = zext i8 %249 to i32
  %or1872 = or i32 %conv1871, 201
  %cmp1873 = icmp ne i32 %or1872, 251
  br i1 %cmp1873, label %if.then1875, label %if.end1876

if.then1875:                                      ; preds = %if.end1868
  store i8 0, i8* %correct, align 1
  br label %if.end1876

if.end1876:                                       ; preds = %if.then1875, %if.end1868
  %call1877 = call i32 @seek(i32 noundef 13, i32 noundef 0)
  %call1878 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %250 = load i8, i8* %buf, align 1
  %conv1879 = zext i8 %250 to i32
  %or1880 = or i32 %conv1879, 26
  %cmp1881 = icmp ne i32 %or1880, 59
  br i1 %cmp1881, label %if.then1883, label %if.end1884

if.then1883:                                      ; preds = %if.end1876
  store i8 0, i8* %correct, align 1
  br label %if.end1884

if.end1884:                                       ; preds = %if.then1883, %if.end1876
  %call1885 = call i32 @seek(i32 noundef 5, i32 noundef 0)
  %call1886 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %251 = load i8, i8* %buf, align 1
  %conv1887 = zext i8 %251 to i32
  %and1888 = and i32 %conv1887, 23
  %cmp1889 = icmp ne i32 %and1888, 16
  br i1 %cmp1889, label %if.then1891, label %if.end1892

if.then1891:                                      ; preds = %if.end1884
  store i8 0, i8* %correct, align 1
  br label %if.end1892

if.end1892:                                       ; preds = %if.then1891, %if.end1884
  %call1893 = call i32 @seek(i32 noundef 17, i32 noundef 0)
  %call1894 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %252 = load i8, i8* %buf, align 1
  %conv1895 = zext i8 %252 to i32
  %cmp1896 = icmp slt i32 %conv1895, 28
  br i1 %cmp1896, label %if.then1898, label %if.end1899

if.then1898:                                      ; preds = %if.end1892
  store i8 0, i8* %correct, align 1
  br label %if.end1899

if.end1899:                                       ; preds = %if.then1898, %if.end1892
  %call1900 = call i32 @seek(i32 noundef -31, i32 noundef 2)
  %call1901 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %253 = load i8, i8* %buf, align 1
  %conv1902 = zext i8 %253 to i32
  %and1903 = and i32 %conv1902, 17
  %cmp1904 = icmp ne i32 %and1903, 17
  br i1 %cmp1904, label %if.then1906, label %if.end1907

if.then1906:                                      ; preds = %if.end1899
  store i8 0, i8* %correct, align 1
  br label %if.end1907

if.end1907:                                       ; preds = %if.then1906, %if.end1899
  %call1908 = call i32 @seek(i32 noundef 14, i32 noundef 0)
  %call1909 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %254 = load i8, i8* %buf, align 1
  %conv1910 = zext i8 %254 to i32
  %and1911 = and i32 %conv1910, 247
  %cmp1912 = icmp ne i32 %and1911, 102
  br i1 %cmp1912, label %if.then1914, label %if.end1915

if.then1914:                                      ; preds = %if.end1907
  store i8 0, i8* %correct, align 1
  br label %if.end1915

if.end1915:                                       ; preds = %if.then1914, %if.end1907
  %call1916 = call i32 @seek(i32 noundef -40, i32 noundef 2)
  %call1917 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %255 = load i8, i8* %buf, align 1
  %conv1918 = zext i8 %255 to i32
  %and1919 = and i32 %conv1918, 232
  %cmp1920 = icmp ne i32 %and1919, 104
  br i1 %cmp1920, label %if.then1922, label %if.end1923

if.then1922:                                      ; preds = %if.end1915
  store i8 0, i8* %correct, align 1
  br label %if.end1923

if.end1923:                                       ; preds = %if.then1922, %if.end1915
  %call1924 = call i32 @seek(i32 noundef -16, i32 noundef 2)
  %call1925 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %256 = load i8, i8* %buf, align 1
  %conv1926 = zext i8 %256 to i32
  %cmp1927 = icmp slt i32 %conv1926, 12
  br i1 %cmp1927, label %if.then1929, label %if.end1930

if.then1929:                                      ; preds = %if.end1923
  store i8 0, i8* %correct, align 1
  br label %if.end1930

if.end1930:                                       ; preds = %if.then1929, %if.end1923
  %call1931 = call i32 @seek(i32 noundef -38, i32 noundef 2)
  %call1932 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %257 = load i8, i8* %buf, align 1
  %conv1933 = zext i8 %257 to i32
  %or1934 = or i32 %conv1933, 197
  %cmp1935 = icmp ne i32 %or1934, 245
  br i1 %cmp1935, label %if.then1937, label %if.end1938

if.then1937:                                      ; preds = %if.end1930
  store i8 0, i8* %correct, align 1
  br label %if.end1938

if.end1938:                                       ; preds = %if.then1937, %if.end1930
  %call1939 = call i32 @seek(i32 noundef 36, i32 noundef 0)
  %call1940 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %258 = load i8, i8* %buf, align 1
  %conv1941 = zext i8 %258 to i32
  %or1942 = or i32 %conv1941, 59
  %cmp1943 = icmp ne i32 %or1942, 127
  br i1 %cmp1943, label %if.then1945, label %if.end1946

if.then1945:                                      ; preds = %if.end1938
  store i8 0, i8* %correct, align 1
  br label %if.end1946

if.end1946:                                       ; preds = %if.then1945, %if.end1938
  %call1947 = call i32 @seek(i32 noundef 26, i32 noundef 0)
  %call1948 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %259 = load i8, i8* %buf, align 1
  %conv1949 = zext i8 %259 to i32
  %cmp1950 = icmp slt i32 %conv1949, 101
  br i1 %cmp1950, label %if.then1952, label %if.end1953

if.then1952:                                      ; preds = %if.end1946
  store i8 0, i8* %correct, align 1
  br label %if.end1953

if.end1953:                                       ; preds = %if.then1952, %if.end1946
  %call1954 = call i32 @seek(i32 noundef -15, i32 noundef 2)
  %call1955 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %260 = load i8, i8* %buf, align 1
  %conv1956 = zext i8 %260 to i32
  %cmp1957 = icmp sge i32 %conv1956, 218
  br i1 %cmp1957, label %if.then1959, label %if.end1960

if.then1959:                                      ; preds = %if.end1953
  store i8 0, i8* %correct, align 1
  br label %if.end1960

if.end1960:                                       ; preds = %if.then1959, %if.end1953
  %call1961 = call i32 @seek(i32 noundef 4, i32 noundef 0)
  %call1962 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %261 = load i8, i8* %buf, align 1
  %conv1963 = zext i8 %261 to i32
  %and1964 = and i32 %conv1963, 29
  %cmp1965 = icmp ne i32 %and1964, 25
  br i1 %cmp1965, label %if.then1967, label %if.end1968

if.then1967:                                      ; preds = %if.end1960
  store i8 0, i8* %correct, align 1
  br label %if.end1968

if.end1968:                                       ; preds = %if.then1967, %if.end1960
  %call1969 = call i32 @seek(i32 noundef 12, i32 noundef 0)
  %call1970 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %262 = load i8, i8* %buf, align 1
  %conv1971 = zext i8 %262 to i32
  %and1972 = and i32 %conv1971, 132
  %cmp1973 = icmp ne i32 %and1972, 0
  br i1 %cmp1973, label %if.then1975, label %if.end1976

if.then1975:                                      ; preds = %if.end1968
  store i8 0, i8* %correct, align 1
  br label %if.end1976

if.end1976:                                       ; preds = %if.then1975, %if.end1968
  %call1977 = call i32 @seek(i32 noundef 11, i32 noundef 0)
  %call1978 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %263 = load i8, i8* %buf, align 1
  %conv1979 = zext i8 %263 to i32
  %and1980 = and i32 %conv1979, 249
  %cmp1981 = icmp ne i32 %and1980, 89
  br i1 %cmp1981, label %if.then1983, label %if.end1984

if.then1983:                                      ; preds = %if.end1976
  store i8 0, i8* %correct, align 1
  br label %if.end1984

if.end1984:                                       ; preds = %if.then1983, %if.end1976
  %call1985 = call i32 @seek(i32 noundef 11, i32 noundef 0)
  %call1986 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %264 = load i8, i8* %buf, align 1
  %conv1987 = zext i8 %264 to i32
  %or1988 = or i32 %conv1987, 220
  %cmp1989 = icmp ne i32 %or1988, 223
  br i1 %cmp1989, label %if.then1991, label %if.end1992

if.then1991:                                      ; preds = %if.end1984
  store i8 0, i8* %correct, align 1
  br label %if.end1992

if.end1992:                                       ; preds = %if.then1991, %if.end1984
  %call1993 = call i32 @seek(i32 noundef -37, i32 noundef 2)
  %call1994 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %265 = load i8, i8* %buf, align 1
  %conv1995 = zext i8 %265 to i32
  %cmp1996 = icmp sge i32 %conv1995, 253
  br i1 %cmp1996, label %if.then1998, label %if.end1999

if.then1998:                                      ; preds = %if.end1992
  store i8 0, i8* %correct, align 1
  br label %if.end1999

if.end1999:                                       ; preds = %if.then1998, %if.end1992
  %call2000 = call i32 @seek(i32 noundef 26, i32 noundef 0)
  %call2001 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %266 = load i8, i8* %buf, align 1
  %conv2002 = zext i8 %266 to i32
  %and2003 = and i32 %conv2002, 24
  %cmp2004 = icmp ne i32 %and2003, 16
  br i1 %cmp2004, label %if.then2006, label %if.end2007

if.then2006:                                      ; preds = %if.end1999
  store i8 0, i8* %correct, align 1
  br label %if.end2007

if.end2007:                                       ; preds = %if.then2006, %if.end1999
  %call2008 = call i32 @seek(i32 noundef 10, i32 noundef 0)
  %call2009 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %267 = load i8, i8* %buf, align 1
  %conv2010 = zext i8 %267 to i32
  %or2011 = or i32 %conv2010, 58
  %cmp2012 = icmp ne i32 %or2011, 59
  br i1 %cmp2012, label %if.then2014, label %if.end2015

if.then2014:                                      ; preds = %if.end2007
  store i8 0, i8* %correct, align 1
  br label %if.end2015

if.end2015:                                       ; preds = %if.then2014, %if.end2007
  %call2016 = call i32 @seek(i32 noundef 13, i32 noundef 0)
  %call2017 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %268 = load i8, i8* %buf, align 1
  %conv2018 = zext i8 %268 to i32
  %or2019 = or i32 %conv2018, 42
  %cmp2020 = icmp ne i32 %or2019, 59
  br i1 %cmp2020, label %if.then2022, label %if.end2023

if.then2022:                                      ; preds = %if.end2015
  store i8 0, i8* %correct, align 1
  br label %if.end2023

if.end2023:                                       ; preds = %if.then2022, %if.end2015
  %call2024 = call i32 @seek(i32 noundef -13, i32 noundef 2)
  %call2025 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %269 = load i8, i8* %buf, align 1
  %conv2026 = zext i8 %269 to i32
  %and2027 = and i32 %conv2026, 138
  %cmp2028 = icmp ne i32 %and2027, 0
  br i1 %cmp2028, label %if.then2030, label %if.end2031

if.then2030:                                      ; preds = %if.end2023
  store i8 0, i8* %correct, align 1
  br label %if.end2031

if.end2031:                                       ; preds = %if.then2030, %if.end2023
  %call2032 = call i32 @seek(i32 noundef -29, i32 noundef 2)
  %call2033 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %270 = load i8, i8* %buf, align 1
  %conv2034 = zext i8 %270 to i32
  %and2035 = and i32 %conv2034, 163
  %cmp2036 = icmp ne i32 %and2035, 32
  br i1 %cmp2036, label %if.then2038, label %if.end2039

if.then2038:                                      ; preds = %if.end2031
  store i8 0, i8* %correct, align 1
  br label %if.end2039

if.end2039:                                       ; preds = %if.then2038, %if.end2031
  %call2040 = call i32 @seek(i32 noundef 6, i32 noundef 0)
  %call2041 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %271 = load i8, i8* %buf, align 1
  %conv2042 = zext i8 %271 to i32
  %cmp2043 = icmp sge i32 %conv2042, 153
  br i1 %cmp2043, label %if.then2045, label %if.end2046

if.then2045:                                      ; preds = %if.end2039
  store i8 0, i8* %correct, align 1
  br label %if.end2046

if.end2046:                                       ; preds = %if.then2045, %if.end2039
  %call2047 = call i32 @seek(i32 noundef -39, i32 noundef 2)
  %call2048 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %272 = load i8, i8* %buf, align 1
  %conv2049 = zext i8 %272 to i32
  %and2050 = and i32 %conv2049, 140
  %cmp2051 = icmp ne i32 %and2050, 0
  br i1 %cmp2051, label %if.then2053, label %if.end2054

if.then2053:                                      ; preds = %if.end2046
  store i8 0, i8* %correct, align 1
  br label %if.end2054

if.end2054:                                       ; preds = %if.then2053, %if.end2046
  %call2055 = call i32 @seek(i32 noundef -9, i32 noundef 2)
  %call2056 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %273 = load i8, i8* %buf, align 1
  %conv2057 = zext i8 %273 to i32
  %or2058 = or i32 %conv2057, 74
  %cmp2059 = icmp ne i32 %or2058, 95
  br i1 %cmp2059, label %if.then2061, label %if.end2062

if.then2061:                                      ; preds = %if.end2054
  store i8 0, i8* %correct, align 1
  br label %if.end2062

if.end2062:                                       ; preds = %if.then2061, %if.end2054
  %call2063 = call i32 @seek(i32 noundef 23, i32 noundef 0)
  %call2064 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %274 = load i8, i8* %buf, align 1
  %conv2065 = zext i8 %274 to i32
  %and2066 = and i32 %conv2065, 235
  %cmp2067 = icmp ne i32 %and2066, 96
  br i1 %cmp2067, label %if.then2069, label %if.end2070

if.then2069:                                      ; preds = %if.end2062
  store i8 0, i8* %correct, align 1
  br label %if.end2070

if.end2070:                                       ; preds = %if.then2069, %if.end2062
  %call2071 = call i32 @seek(i32 noundef -27, i32 noundef 2)
  %call2072 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %275 = load i8, i8* %buf, align 1
  %conv2073 = zext i8 %275 to i32
  %or2074 = or i32 %conv2073, 86
  %cmp2075 = icmp ne i32 %or2074, 118
  br i1 %cmp2075, label %if.then2077, label %if.end2078

if.then2077:                                      ; preds = %if.end2070
  store i8 0, i8* %correct, align 1
  br label %if.end2078

if.end2078:                                       ; preds = %if.then2077, %if.end2070
  %call2079 = call i32 @seek(i32 noundef 42, i32 noundef 0)
  %call2080 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %276 = load i8, i8* %buf, align 1
  %conv2081 = zext i8 %276 to i32
  %cmp2082 = icmp sge i32 %conv2081, 244
  br i1 %cmp2082, label %if.then2084, label %if.end2085

if.then2084:                                      ; preds = %if.end2078
  store i8 0, i8* %correct, align 1
  br label %if.end2085

if.end2085:                                       ; preds = %if.then2084, %if.end2078
  %call2086 = call i32 @seek(i32 noundef -11, i32 noundef 2)
  %call2087 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %277 = load i8, i8* %buf, align 1
  %conv2088 = zext i8 %277 to i32
  %or2089 = or i32 %conv2088, 21
  %cmp2090 = icmp ne i32 %or2089, 127
  br i1 %cmp2090, label %if.then2092, label %if.end2093

if.then2092:                                      ; preds = %if.end2085
  store i8 0, i8* %correct, align 1
  br label %if.end2093

if.end2093:                                       ; preds = %if.then2092, %if.end2085
  %call2094 = call i32 @seek(i32 noundef 18, i32 noundef 0)
  %call2095 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %278 = load i8, i8* %buf, align 1
  %conv2096 = zext i8 %278 to i32
  %and2097 = and i32 %conv2096, 51
  %cmp2098 = icmp ne i32 %and2097, 34
  br i1 %cmp2098, label %if.then2100, label %if.end2101

if.then2100:                                      ; preds = %if.end2093
  store i8 0, i8* %correct, align 1
  br label %if.end2101

if.end2101:                                       ; preds = %if.then2100, %if.end2093
  %call2102 = call i32 @seek(i32 noundef 41, i32 noundef 0)
  %call2103 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %279 = load i8, i8* %buf, align 1
  %conv2104 = zext i8 %279 to i32
  %cmp2105 = icmp slt i32 %conv2104, 59
  br i1 %cmp2105, label %if.then2107, label %if.end2108

if.then2107:                                      ; preds = %if.end2101
  store i8 0, i8* %correct, align 1
  br label %if.end2108

if.end2108:                                       ; preds = %if.then2107, %if.end2101
  %call2109 = call i32 @seek(i32 noundef 37, i32 noundef 0)
  %call2110 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %280 = load i8, i8* %buf, align 1
  %conv2111 = zext i8 %280 to i32
  %or2112 = or i32 %conv2111, 5
  %cmp2113 = icmp ne i32 %or2112, 101
  br i1 %cmp2113, label %if.then2115, label %if.end2116

if.then2115:                                      ; preds = %if.end2108
  store i8 0, i8* %correct, align 1
  br label %if.end2116

if.end2116:                                       ; preds = %if.then2115, %if.end2108
  %call2117 = call i32 @seek(i32 noundef 13, i32 noundef 0)
  %call2118 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %281 = load i8, i8* %buf, align 1
  %conv2119 = zext i8 %281 to i32
  %or2120 = or i32 %conv2119, 42
  %cmp2121 = icmp ne i32 %or2120, 59
  br i1 %cmp2121, label %if.then2123, label %if.end2124

if.then2123:                                      ; preds = %if.end2116
  store i8 0, i8* %correct, align 1
  br label %if.end2124

if.end2124:                                       ; preds = %if.then2123, %if.end2116
  %call2125 = call i32 @seek(i32 noundef -37, i32 noundef 2)
  %call2126 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %282 = load i8, i8* %buf, align 1
  %conv2127 = zext i8 %282 to i32
  %and2128 = and i32 %conv2127, 239
  %cmp2129 = icmp ne i32 %and2128, 79
  br i1 %cmp2129, label %if.then2131, label %if.end2132

if.then2131:                                      ; preds = %if.end2124
  store i8 0, i8* %correct, align 1
  br label %if.end2132

if.end2132:                                       ; preds = %if.then2131, %if.end2124
  %call2133 = call i32 @seek(i32 noundef 31, i32 noundef 0)
  %call2134 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %283 = load i8, i8* %buf, align 1
  %conv2135 = zext i8 %283 to i32
  %and2136 = and i32 %conv2135, 204
  %cmp2137 = icmp ne i32 %and2136, 68
  br i1 %cmp2137, label %if.then2139, label %if.end2140

if.then2139:                                      ; preds = %if.end2132
  store i8 0, i8* %correct, align 1
  br label %if.end2140

if.end2140:                                       ; preds = %if.then2139, %if.end2132
  %call2141 = call i32 @seek(i32 noundef 9, i32 noundef 0)
  %call2142 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %284 = load i8, i8* %buf, align 1
  %conv2143 = zext i8 %284 to i32
  %and2144 = and i32 %conv2143, 112
  %cmp2145 = icmp ne i32 %and2144, 112
  br i1 %cmp2145, label %if.then2147, label %if.end2148

if.then2147:                                      ; preds = %if.end2140
  store i8 0, i8* %correct, align 1
  br label %if.end2148

if.end2148:                                       ; preds = %if.then2147, %if.end2140
  %call2149 = call i32 @seek(i32 noundef -14, i32 noundef 2)
  %call2150 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %285 = load i8, i8* %buf, align 1
  %conv2151 = zext i8 %285 to i32
  %and2152 = and i32 %conv2151, 185
  %cmp2153 = icmp ne i32 %and2152, 49
  br i1 %cmp2153, label %if.then2155, label %if.end2156

if.then2155:                                      ; preds = %if.end2148
  store i8 0, i8* %correct, align 1
  br label %if.end2156

if.end2156:                                       ; preds = %if.then2155, %if.end2148
  %call2157 = call i32 @seek(i32 noundef -20, i32 noundef 2)
  %call2158 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %286 = load i8, i8* %buf, align 1
  %conv2159 = zext i8 %286 to i32
  %and2160 = and i32 %conv2159, 20
  %cmp2161 = icmp ne i32 %and2160, 20
  br i1 %cmp2161, label %if.then2163, label %if.end2164

if.then2163:                                      ; preds = %if.end2156
  store i8 0, i8* %correct, align 1
  br label %if.end2164

if.end2164:                                       ; preds = %if.then2163, %if.end2156
  %call2165 = call i32 @seek(i32 noundef 38, i32 noundef 0)
  %call2166 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %287 = load i8, i8* %buf, align 1
  %conv2167 = zext i8 %287 to i32
  %cmp2168 = icmp sge i32 %conv2167, 135
  br i1 %cmp2168, label %if.then2170, label %if.end2171

if.then2170:                                      ; preds = %if.end2164
  store i8 0, i8* %correct, align 1
  br label %if.end2171

if.end2171:                                       ; preds = %if.then2170, %if.end2164
  %call2172 = call i32 @seek(i32 noundef -24, i32 noundef 2)
  %call2173 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %288 = load i8, i8* %buf, align 1
  %conv2174 = zext i8 %288 to i32
  %cmp2175 = icmp sge i32 %conv2174, 157
  br i1 %cmp2175, label %if.then2177, label %if.end2178

if.then2177:                                      ; preds = %if.end2171
  store i8 0, i8* %correct, align 1
  br label %if.end2178

if.end2178:                                       ; preds = %if.then2177, %if.end2171
  %call2179 = call i32 @seek(i32 noundef 15, i32 noundef 0)
  %call2180 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %289 = load i8, i8* %buf, align 1
  %conv2181 = zext i8 %289 to i32
  %and2182 = and i32 %conv2181, 181
  %cmp2183 = icmp ne i32 %and2182, 36
  br i1 %cmp2183, label %if.then2185, label %if.end2186

if.then2185:                                      ; preds = %if.end2178
  store i8 0, i8* %correct, align 1
  br label %if.end2186

if.end2186:                                       ; preds = %if.then2185, %if.end2178
  %call2187 = call i32 @seek(i32 noundef -25, i32 noundef 2)
  %call2188 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %290 = load i8, i8* %buf, align 1
  %conv2189 = zext i8 %290 to i32
  %cmp2190 = icmp slt i32 %conv2189, 70
  br i1 %cmp2190, label %if.then2192, label %if.end2193

if.then2192:                                      ; preds = %if.end2186
  store i8 0, i8* %correct, align 1
  br label %if.end2193

if.end2193:                                       ; preds = %if.then2192, %if.end2186
  %call2194 = call i32 @seek(i32 noundef 5, i32 noundef 0)
  %call2195 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %291 = load i8, i8* %buf, align 1
  %conv2196 = zext i8 %291 to i32
  %cmp2197 = icmp sge i32 %conv2196, 154
  br i1 %cmp2197, label %if.then2199, label %if.end2200

if.then2199:                                      ; preds = %if.end2193
  store i8 0, i8* %correct, align 1
  br label %if.end2200

if.end2200:                                       ; preds = %if.then2199, %if.end2193
  %call2201 = call i32 @seek(i32 noundef -5, i32 noundef 2)
  %call2202 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %292 = load i8, i8* %buf, align 1
  %conv2203 = zext i8 %292 to i32
  %and2204 = and i32 %conv2203, 57
  %cmp2205 = icmp ne i32 %and2204, 49
  br i1 %cmp2205, label %if.then2207, label %if.end2208

if.then2207:                                      ; preds = %if.end2200
  store i8 0, i8* %correct, align 1
  br label %if.end2208

if.end2208:                                       ; preds = %if.then2207, %if.end2200
  %call2209 = call i32 @seek(i32 noundef 42, i32 noundef 0)
  %call2210 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %293 = load i8, i8* %buf, align 1
  %conv2211 = zext i8 %293 to i32
  %or2212 = or i32 %conv2211, 36
  %cmp2213 = icmp ne i32 %or2212, 55
  br i1 %cmp2213, label %if.then2215, label %if.end2216

if.then2215:                                      ; preds = %if.end2208
  store i8 0, i8* %correct, align 1
  br label %if.end2216

if.end2216:                                       ; preds = %if.then2215, %if.end2208
  %call2217 = call i32 @seek(i32 noundef 26, i32 noundef 0)
  %call2218 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %294 = load i8, i8* %buf, align 1
  %conv2219 = zext i8 %294 to i32
  %cmp2220 = icmp sge i32 %conv2219, 227
  br i1 %cmp2220, label %if.then2222, label %if.end2223

if.then2222:                                      ; preds = %if.end2216
  store i8 0, i8* %correct, align 1
  br label %if.end2223

if.end2223:                                       ; preds = %if.then2222, %if.end2216
  %call2224 = call i32 @seek(i32 noundef 9, i32 noundef 0)
  %call2225 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %295 = load i8, i8* %buf, align 1
  %conv2226 = zext i8 %295 to i32
  %or2227 = or i32 %conv2226, 206
  %cmp2228 = icmp ne i32 %or2227, 254
  br i1 %cmp2228, label %if.then2230, label %if.end2231

if.then2230:                                      ; preds = %if.end2223
  store i8 0, i8* %correct, align 1
  br label %if.end2231

if.end2231:                                       ; preds = %if.then2230, %if.end2223
  %call2232 = call i32 @seek(i32 noundef -40, i32 noundef 2)
  %call2233 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %296 = load i8, i8* %buf, align 1
  %conv2234 = zext i8 %296 to i32
  %cmp2235 = icmp sge i32 %conv2234, 181
  br i1 %cmp2235, label %if.then2237, label %if.end2238

if.then2237:                                      ; preds = %if.end2231
  store i8 0, i8* %correct, align 1
  br label %if.end2238

if.end2238:                                       ; preds = %if.then2237, %if.end2231
  %call2239 = call i32 @seek(i32 noundef -9, i32 noundef 2)
  %call2240 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %297 = load i8, i8* %buf, align 1
  %conv2241 = zext i8 %297 to i32
  %or2242 = or i32 %conv2241, 92
  %cmp2243 = icmp ne i32 %or2242, 95
  br i1 %cmp2243, label %if.then2245, label %if.end2246

if.then2245:                                      ; preds = %if.end2238
  store i8 0, i8* %correct, align 1
  br label %if.end2246

if.end2246:                                       ; preds = %if.then2245, %if.end2238
  %call2247 = call i32 @seek(i32 noundef -17, i32 noundef 2)
  %call2248 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %298 = load i8, i8* %buf, align 1
  %conv2249 = zext i8 %298 to i32
  %and2250 = and i32 %conv2249, 228
  %cmp2251 = icmp ne i32 %and2250, 68
  br i1 %cmp2251, label %if.then2253, label %if.end2254

if.then2253:                                      ; preds = %if.end2246
  store i8 0, i8* %correct, align 1
  br label %if.end2254

if.end2254:                                       ; preds = %if.then2253, %if.end2246
  %call2255 = call i32 @seek(i32 noundef 4, i32 noundef 0)
  %call2256 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %299 = load i8, i8* %buf, align 1
  %conv2257 = zext i8 %299 to i32
  %and2258 = and i32 %conv2257, 137
  %cmp2259 = icmp ne i32 %and2258, 9
  br i1 %cmp2259, label %if.then2261, label %if.end2262

if.then2261:                                      ; preds = %if.end2254
  store i8 0, i8* %correct, align 1
  br label %if.end2262

if.end2262:                                       ; preds = %if.then2261, %if.end2254
  %call2263 = call i32 @seek(i32 noundef -36, i32 noundef 2)
  %call2264 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %300 = load i8, i8* %buf, align 1
  %conv2265 = zext i8 %300 to i32
  %cmp2266 = icmp sge i32 %conv2265, 244
  br i1 %cmp2266, label %if.then2268, label %if.end2269

if.then2268:                                      ; preds = %if.end2262
  store i8 0, i8* %correct, align 1
  br label %if.end2269

if.end2269:                                       ; preds = %if.then2268, %if.end2262
  %call2270 = call i32 @seek(i32 noundef 34, i32 noundef 0)
  %call2271 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %301 = load i8, i8* %buf, align 1
  %conv2272 = zext i8 %301 to i32
  %cmp2273 = icmp sge i32 %conv2272, 237
  br i1 %cmp2273, label %if.then2275, label %if.end2276

if.then2275:                                      ; preds = %if.end2269
  store i8 0, i8* %correct, align 1
  br label %if.end2276

if.end2276:                                       ; preds = %if.then2275, %if.end2269
  %call2277 = call i32 @seek(i32 noundef 27, i32 noundef 0)
  %call2278 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %302 = load i8, i8* %buf, align 1
  %conv2279 = zext i8 %302 to i32
  %and2280 = and i32 %conv2279, 179
  %cmp2281 = icmp ne i32 %and2280, 19
  br i1 %cmp2281, label %if.then2283, label %if.end2284

if.then2283:                                      ; preds = %if.end2276
  store i8 0, i8* %correct, align 1
  br label %if.end2284

if.end2284:                                       ; preds = %if.then2283, %if.end2276
  %call2285 = call i32 @seek(i32 noundef -28, i32 noundef 2)
  %call2286 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %303 = load i8, i8* %buf, align 1
  %conv2287 = zext i8 %303 to i32
  %and2288 = and i32 %conv2287, 82
  %cmp2289 = icmp ne i32 %and2288, 82
  br i1 %cmp2289, label %if.then2291, label %if.end2292

if.then2291:                                      ; preds = %if.end2284
  store i8 0, i8* %correct, align 1
  br label %if.end2292

if.end2292:                                       ; preds = %if.then2291, %if.end2284
  %call2293 = call i32 @seek(i32 noundef -3, i32 noundef 2)
  %call2294 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %304 = load i8, i8* %buf, align 1
  %conv2295 = zext i8 %304 to i32
  %or2296 = or i32 %conv2295, 49
  %cmp2297 = icmp ne i32 %or2296, 115
  br i1 %cmp2297, label %if.then2299, label %if.end2300

if.then2299:                                      ; preds = %if.end2292
  store i8 0, i8* %correct, align 1
  br label %if.end2300

if.end2300:                                       ; preds = %if.then2299, %if.end2292
  %call2301 = call i32 @seek(i32 noundef 30, i32 noundef 0)
  %call2302 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %305 = load i8, i8* %buf, align 1
  %conv2303 = zext i8 %305 to i32
  %cmp2304 = icmp slt i32 %conv2303, 35
  br i1 %cmp2304, label %if.then2306, label %if.end2307

if.then2306:                                      ; preds = %if.end2300
  store i8 0, i8* %correct, align 1
  br label %if.end2307

if.end2307:                                       ; preds = %if.then2306, %if.end2300
  %call2308 = call i32 @seek(i32 noundef 21, i32 noundef 0)
  %call2309 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %306 = load i8, i8* %buf, align 1
  %conv2310 = zext i8 %306 to i32
  %cmp2311 = icmp sge i32 %conv2310, 122
  br i1 %cmp2311, label %if.then2313, label %if.end2314

if.then2313:                                      ; preds = %if.end2307
  store i8 0, i8* %correct, align 1
  br label %if.end2314

if.end2314:                                       ; preds = %if.then2313, %if.end2307
  %call2315 = call i32 @seek(i32 noundef -33, i32 noundef 2)
  %call2316 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %307 = load i8, i8* %buf, align 1
  %conv2317 = zext i8 %307 to i32
  %and2318 = and i32 %conv2317, 8
  %cmp2319 = icmp ne i32 %and2318, 8
  br i1 %cmp2319, label %if.then2321, label %if.end2322

if.then2321:                                      ; preds = %if.end2314
  store i8 0, i8* %correct, align 1
  br label %if.end2322

if.end2322:                                       ; preds = %if.then2321, %if.end2314
  %call2323 = call i32 @seek(i32 noundef -30, i32 noundef 2)
  %call2324 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %308 = load i8, i8* %buf, align 1
  %conv2325 = zext i8 %308 to i32
  %or2326 = or i32 %conv2325, 244
  %cmp2327 = icmp ne i32 %or2326, 254
  br i1 %cmp2327, label %if.then2329, label %if.end2330

if.then2329:                                      ; preds = %if.end2322
  store i8 0, i8* %correct, align 1
  br label %if.end2330

if.end2330:                                       ; preds = %if.then2329, %if.end2322
  %call2331 = call i32 @seek(i32 noundef 30, i32 noundef 0)
  %call2332 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %309 = load i8, i8* %buf, align 1
  %conv2333 = zext i8 %309 to i32
  %cmp2334 = icmp sge i32 %conv2333, 82
  br i1 %cmp2334, label %if.then2336, label %if.end2337

if.then2336:                                      ; preds = %if.end2330
  store i8 0, i8* %correct, align 1
  br label %if.end2337

if.end2337:                                       ; preds = %if.then2336, %if.end2330
  %call2338 = call i32 @seek(i32 noundef -19, i32 noundef 2)
  %call2339 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %310 = load i8, i8* %buf, align 1
  %conv2340 = zext i8 %310 to i32
  %and2341 = and i32 %conv2340, 193
  %cmp2342 = icmp ne i32 %and2341, 65
  br i1 %cmp2342, label %if.then2344, label %if.end2345

if.then2344:                                      ; preds = %if.end2337
  store i8 0, i8* %correct, align 1
  br label %if.end2345

if.end2345:                                       ; preds = %if.then2344, %if.end2337
  %call2346 = call i32 @seek(i32 noundef 10, i32 noundef 0)
  %call2347 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %311 = load i8, i8* %buf, align 1
  %conv2348 = zext i8 %311 to i32
  %and2349 = and i32 %conv2348, 29
  %cmp2350 = icmp ne i32 %and2349, 17
  br i1 %cmp2350, label %if.then2352, label %if.end2353

if.then2352:                                      ; preds = %if.end2345
  store i8 0, i8* %correct, align 1
  br label %if.end2353

if.end2353:                                       ; preds = %if.then2352, %if.end2345
  %call2354 = call i32 @seek(i32 noundef 26, i32 noundef 0)
  %call2355 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %312 = load i8, i8* %buf, align 1
  %conv2356 = zext i8 %312 to i32
  %cmp2357 = icmp sge i32 %conv2356, 210
  br i1 %cmp2357, label %if.then2359, label %if.end2360

if.then2359:                                      ; preds = %if.end2353
  store i8 0, i8* %correct, align 1
  br label %if.end2360

if.end2360:                                       ; preds = %if.then2359, %if.end2353
  %call2361 = call i32 @seek(i32 noundef 13, i32 noundef 0)
  %call2362 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %313 = load i8, i8* %buf, align 1
  %conv2363 = zext i8 %313 to i32
  %cmp2364 = icmp sge i32 %conv2363, 110
  br i1 %cmp2364, label %if.then2366, label %if.end2367

if.then2366:                                      ; preds = %if.end2360
  store i8 0, i8* %correct, align 1
  br label %if.end2367

if.end2367:                                       ; preds = %if.then2366, %if.end2360
  %call2368 = call i32 @seek(i32 noundef 24, i32 noundef 0)
  %call2369 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %314 = load i8, i8* %buf, align 1
  %conv2370 = zext i8 %314 to i32
  %or2371 = or i32 %conv2370, 170
  %cmp2372 = icmp ne i32 %or2371, 255
  br i1 %cmp2372, label %if.then2374, label %if.end2375

if.then2374:                                      ; preds = %if.end2367
  store i8 0, i8* %correct, align 1
  br label %if.end2375

if.end2375:                                       ; preds = %if.then2374, %if.end2367
  %call2376 = call i32 @seek(i32 noundef -14, i32 noundef 2)
  %call2377 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %315 = load i8, i8* %buf, align 1
  %conv2378 = zext i8 %315 to i32
  %and2379 = and i32 %conv2378, 64
  %cmp2380 = icmp ne i32 %and2379, 0
  br i1 %cmp2380, label %if.then2382, label %if.end2383

if.then2382:                                      ; preds = %if.end2375
  store i8 0, i8* %correct, align 1
  br label %if.end2383

if.end2383:                                       ; preds = %if.then2382, %if.end2375
  %call2384 = call i32 @seek(i32 noundef -25, i32 noundef 2)
  %call2385 = call i32 @read(i8* noundef %buf, i32 noundef 1)
  %316 = load i8, i8* %buf, align 1
  %conv2386 = zext i8 %316 to i32
  %or2387 = or i32 %conv2386, 216
  %cmp2388 = icmp ne i32 %or2387, 223
  br i1 %cmp2388, label %if.then2390, label %if.end2391

if.then2390:                                      ; preds = %if.end2383
  store i8 0, i8* %correct, align 1
  br label %if.end2391

if.end2391:                                       ; preds = %if.then2390, %if.end2383
  store i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.4, i64 0, i64 0), i8** %virusname.addr.i2397, align 8
  %317 = load i8*, i8** %virusname.addr.i2397, align 8
  %call.i2398 = call i32 @setvirusname(i8* noundef %317, i32 noundef 0) #2
  %318 = load i8, i8* %correct, align 1
  %conv2392 = zext i8 %318 to i32
  %cmp2393 = icmp eq i32 %conv2392, 0
  br i1 %cmp2393, label %if.then2395, label %if.end2396

if.then2395:                                      ; preds = %if.end2391
  store i32 -1, i32* %retval, align 4
  br label %return

if.end2396:                                       ; preds = %if.end2391
  store i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.5, i64 0, i64 0), i8** %virusname.addr.i, align 8
  %319 = load i8*, i8** %virusname.addr.i, align 8
  %call.i = call i32 @setvirusname(i8* noundef %319, i32 noundef 0) #2
  store i32 0, i32* %retval, align 4
  br label %return

return:                                           ; preds = %if.end2396, %if.then2395, %if.then5, %if.then
  %320 = load i32, i32* %retval, align 4
  ret i32 %320
}

declare i32 @seek(i32 noundef, i32 noundef) #1

declare i32 @read(i8* noundef, i32 noundef) #1

declare i32 @setvirusname(i8* noundef, i32 noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 16.0.6 (23ubuntu4)"}
