NAME = vm
BYTECODE = bytecode.bin

SRC = vm.cpp
GENERATOR = generator.py

all: $(NAME) $(BYTECODE)

$(NAME): $(SRC)
	g++ -o $(NAME) $(SRC)
	strip -s $(NAME)

$(BYTECODE): $(GENERATOR)
	python3 $(GENERATOR)

fclean:
	rm -f $(NAME) $(BYTECODE)

re: fclean all

.PHONY: all fclean re
