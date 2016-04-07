all: montador

montador: montador.o
	g++ -o montador montador.o

montador.o: montador.cpp
	g++ -c montador.cpp	

clean:
	rm montador.o montador