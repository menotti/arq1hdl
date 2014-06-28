//referencia utilizada: http://alanhogan.com/asu/assembler.php?source
// EWRRO QUANDO ESQUECE DE COLOCAR ESPA�O

//FALTA INSTRU��ES DO TIP BRANCHS conversor com n�meros negativos
//CONVERSOR DE BIN�RIO PARA DECIMAL

#include <iostream>
#include <fstream>
#include <string>
#include <stdexcept>
#include <ctype.h>
#include "stdlib.h"
#define tam 20

using namespace std;
using std::string;

struct linha
{
    string instrucao;
    string label;
    int endereco;
};

//transforma a string em num�rico para o switch
int stringHash(std::string word)
{
	int sum = 0;
	if(word == "noop")
	{
		sum = 1000;
	}
	else if (word == "ori")
	{
		sum = 11;
	}
	else if (word == "slti")
	{
		sum = 1002;
	}
	else if (word == "sub")
	{
		sum = 1003;
	}
	else if (word == "xori")
	{
		sum = 1004;
	}
	else
	{
		for(int i =0;i<word.length();i++)
		{
			sum+=word[i];
		}

	}

	return sum;
}

string tirarCaracteres(string word)
{
    int i=0;
    int j;
    int tamanho=word.length();
    while(i<tamanho)
    {
            if(word[i]=='(' || word[i]==')' || word[i]==',' || word[i]==':')
            {
                for(j=i;j<word.length();j++)
                    word[j]=word[j+1];
                tamanho--;
            }
            i++;
    }

        word[i]='\0';
        string aux;
        i=0;
        while(word[i]!='\0')
        {
            aux+=word[i];
            i++;
        }

    return aux;
}

string separarPalavra(string line, int *i)
{
    string word;
    while(!isspace(line[*i]) && line[*i]!='\0')
    {
        word+=line[*i];
        *i=*i+1;
    }

    word = tirarCaracteres(word);
    return word;

}

string defineRegistrador(string word)
{

    if(word == "$zero" || word =="$0" )
        return "00000";//0
    else
        if(word == "$v0")
            return "00010"; //2
        else
            if(word == "$v1")
                return "00011";
            else
                if(word == "$a0")
                    return "00100";
                else
                    if(word == "$a1")
                        return "00101";
                    else
                        if(word == "$a2")
                            return "00110";
                        else
                            if(word == "$a3")
                                return "00111";
                            else
                                if(word == "$t0")
                                    return "01000";
                                else
                                    if(word == "$t1")
                                        return "01001";
                                    else
                                        if(word == "$t2")
                                            return "01010";
                                        else
                                            if(word == "$t3")
                                                return "01011";
                                            else
                                                if(word == "$t4")
                                                    return "01100";
                                                else
                                                    if(word == "$t5")
                                                        return "01101";
                                                    else
                                                        if(word == "$t6")
                                                            return "01110";
                                                        else
                                                            if(word == "$t7")
                                                                return "01111";

            return "00000"; //quando n�o for nenhum dos registradores
                                                            //colocar o resto da tabela quando passar pra tcl
}

linha dividirLinha(string word)
{
    linha aux1;
    int i=0;
    int j=0;
    int tamanho=word.length();
    while(i<tamanho)
    {
            if(word[i]==':')
            {
                j=i+1;
            }
            i++;
    }

    i=0;
    string aux, aux2;
    if(j!=0)
    {
        while(i<j)
        {
            aux+=word[i];
            i++;

        }
        aux1.label=aux;
        while(j<word.length())
        {
            aux2+=word[j];
            j++;
        }
        aux1.instrucao=aux2;
    }
    else
        aux1.instrucao=word;
    return aux1;
}

bool procuraLabel(linha *aux, string label, int *endereco)
{
    int i;

    for(i=0;i<tam;i++)
    {
        if(aux[i].label==label)
        {

            *endereco=aux[i].endereco;
            return true;
        }
    }

    return false;
}

int defineTipoInstrucao(string word)
{
    if (word == "add" || word == "addu" || word == "and" || word == "or" || word == "sub" || word == "xor" || word == "slt"
    || word == "subu" || word == "sltu" || word == "div" || word == "divu" || word == "mfhi" || word == "mfhi"
    || word == "mflo" || word == "mult" || word=="multu" || word == "sllv" || word == "srlv") //colocar instru��es do tipo r;
            return 1; //tipo R
    else if(word == "lw" || word == "sw"  || word == "lb" || word == "lbu" || word == "sw" || word == "lui" || word == "sb")
        return 2; //tipo I
    else if (word == "andi" || word == "addiu" || word == "sll" ||  word == "addi" || word == "ori" || word == "xori" || word == "slti"
    || word == "sltiu" || word == "sra" || word == "srl")
        return 3; //tipo I com immed lugar diferente
    else if (word == "beq" || word == "bne" || word == "bgez" || word == "bgezal" || word == "bltzal"  || word == "bgtz" || word == "blez" || word == "bltz")
        return 4;
    else if (word == "j" || word == "jal" || word == "jr")
        return 5;

        return 0;



}

string defineOP(int word)
{
    string saida="";
    switch(word)
                {

                case 1://add
                    saida = "000000";
                break;

                case 402://addi
                    saida = "001000";
                break;

                case 519://addiu
                    saida =  "001001";
                break;

                case 412://andi
                    saida =  "001100";
                break;

                case 312://beq
                    saida =  "000100";
                break;

                case 424://bgez
                    saida = "000001";
                break;

                case 629://bgezal
                    saida =  "000001";
                break;

                case 439://bgtz
                    saida =  "000111";
                break;

                case 429://blez
                    saida =  "000110";
                break;

                case 444://bltz
                    saida =  "000001";
                break;

                case 649://bltzal
                    saida =  "000001";
                break;

                case 309://bne
                    saida = "000101";
                break;

                case 106://j
                    saida =  "000010";
                break;

                case 311://jal
                    saida = "000011";
                break;

                case 220://jr
                    saida =  "000000";
                break;

                case 206://lb
                    saida =  "100000";
                break;

                case 330://lui
                    saida = "001111";
                break;

                case 227://lw
                    saida =  "100011";
                break;

                case 420://mfhi
                    saida = "000000";
                break;

                case 430://mflo
                    saida = "000000";
                break;

                case 450://mult
                    saida = "000000";
                break;

                case 567://multu
                    saida = "000000";
                break;

                case 1000://noop
                    saida =  "000000";
                break;

                case 11://ori
                    saida = "001101";
                break;

                case 213://sb
                    saida = "101000";
                break;

                case 331://sll
                    saida = "000000";
                break;

                case 449://sllv
                    saida = "000000";
                break;

                case 1002://slti
                   saida = "001010";
                break;

                case 561://sltiu
                    saida =  "001011";
                break;

                case 326://sra
                    saida =  "000000";
                break;

                case 337://srl
                    saida =  "000000";
                break;

                case 455://srlv
                    saida = "000000";
                break;

                case 234://sw
                    saida = "101011";
                break;

                case 763://syscall
                    saida = "000000";
                break;

                case 1004://xori
                    saida = "001110";
                break;


                }

            return saida;

}

string defineFunct(string word)
{
    string saida="000000";

    if (word == "add")
        saida = "100000";
    else
        if(word == "addu")
            saida = "100001";
        else
            if(word == "and")
                saida = "100100";
            else
                if (word == "or")
                    saida = "100101";
                else
                    if(word == "sub")
                        saida = "100010";
                    else
                        if(word == "slt")
                            saida = "101010";
                        else
                            if(word == "subu")
                                saida = "100011";
                            else
                                if(word == "sltu")
                                    saida = "101011";
                                else
                                    if(word == "div")
                                        saida = "011010";
                                    else
                                        if(word == "divu")
                                            saida = "011011";
                                        else
                                            if(word == "mfhi")
                                                saida = "010000";
                                            else
                                                if(word == "mflo")
                                                    saida = "010010";
                                                else
                                                    if (word == "mult")
                                                        saida = "011000";
                                                    else
                                                        if(word=="multu")
                                                            saida = "011001";
                                                        else
                                                            if(word=="sllv")
                                                                saida = "000100";
                                                            else
                                                                if(word=="srlv")
                                                                    saida = "000110";
                                                                else
                                                                    if(word=="xor")
                                                                        saida ="100110";
                                                                    else
                                                                        if(word == "sra")
                                                                            saida = "000011";
                                                                        else
                                                                            if(word == "srl")
                                                                                saida = "000010";

    return saida;

}

string conversor(int numero, int quantidade) //converte de decimal para bin�rio
{
    string bin;

    if(numero > 0)
    {

        while (numero > 0)
        {
            if(numero%2==0)
                bin="0" + bin ;
            else
                bin="1" + bin;

            numero=numero/2;
        }

        while (bin.length()<quantidade)
            bin="0"+bin;
    }
        return bin;

}

string defineImmed(std::string word)
{
    int immed;
    string imm;

    immed = atoi( word.c_str());
    imm = conversor(immed,16);


    return imm;
}

string defineShamt(std::string word)
{
    int shamt;
    string sham;

    shamt = atoi( word.c_str());
    sham = conversor(shamt,5);


    return sham;
}

int main ()
{
    linha line[tam];
    string linha, word, linhafinal;
    ifstream arquivo_in;
    ofstream arquivo_out;
    int i=0,j=0;
    int tipo; //define o tipo da instru��o
    string nome,op, rs, rt, rd, shamt, funct,immed; //partes das instru��es
    int endereco;
    arquivo_in.open("teste.asm");
    arquivo_out.open("saida_t.txt");


//lendo o arquivo que foi aberto
	while(!arquivo_in.eof())
	{
        getline(arquivo_in ,linha);
        while (linha[j]!=' ')
            j++;
        line[i]=dividirLinha(linha);
        line[i].endereco=i;
        line[i].label=tirarCaracteres(line[i].label);
        cout<< "Linha '"<<line[i].endereco<<"': ("<<line[i].label<<") '"<< line[i].instrucao << "'"<<endl;
        i++;
	}

cout << "teste" <<endl;
        for(j=0; j<tam;j++)
        {
                linha =".";
            cout<< "Instrucao: '"<< line[j].instrucao << "'"<<endl;
            for(i=0; i<line[j].instrucao.length();i++)
            {
                word = separarPalavra(line[j].instrucao, &i);
                cout<< "Palavra depois: '"<< word << "'"<<endl;
                tipo = defineTipoInstrucao(word);
                nome = word; //esta � o nome da instru��o
                cout <<"Nome instru��o: "<< nome << endl;


                if(tipo == 1)//instru��o do tipo R
                {
                    i++;
                    op=defineOP(tipo);

                    cout << "intrucao: "<< op <<endl;

                    rd=separarPalavra(line[j].instrucao, &i);
                    cout << "registrador: "<< rd <<endl;
                    rd=defineRegistrador(rd);

                    cout << "registrador: "<< rd <<endl;
                    i++;

                    rs=separarPalavra(line[j].instrucao, &i);
                    cout << "registrador: "<< rs <<endl;
                    rs=defineRegistrador(rs);

                    cout << "registrador: "<< rs <<endl;

                    i++;
                    rt=separarPalavra(line[j].instrucao, &i);
                    rt=defineRegistrador(rt);

                    cout << "registrador: "<< rt <<endl;

                    shamt="00000";

                    funct = defineFunct(nome);
                    if(funct == "011010" || funct == "011011" || funct == "011000" || funct == "011001") //formato ins $s, $t ex: mult, div,divu
                        linha = op +  rd + rs+ rt + shamt + funct;
                    else
                        if (funct == "000100" || funct == "000110")
                            linha = op + rt + rs + rd + shamt +funct;
                        else
                            linha = op +  rs + rt+ rd + shamt + funct;
                    cout << linha << endl;

                }
                else
                    if(tipo==2) //tipo I
                    {
                        i++;

                        op=defineOP(stringHash(nome));

                        cout << "op: "<< op<<endl;


                        rt=separarPalavra(line[j].instrucao, &i);
                        cout << "registrador: "<< rt <<endl;
                        rt=defineRegistrador(rt);
                        cout << "registrador: "<< rt <<endl;

                        i++;

                        //offset

                        immed=separarPalavra(line[j].instrucao, &i);
                        immed=defineImmed(immed);
                        cout << "immed: "<< immed <<endl;

                        i++;

                        rs=separarPalavra(line[j].instrucao, &i);
                        cout << "registrador: "<< rs <<endl;
                        rs=defineRegistrador(rs);
                        cout << "registrador: "<< rs <<endl;

                        linha = op + rs + rt + immed;
                    }
                    else
                        if(tipo==3) //tipo I estilo addi
                        {
                                i++;

                                op=defineOP(stringHash(nome));

                                cout << "op: "<< op<<endl;


                                rt=separarPalavra(line[j].instrucao, &i);
                                cout << "registrador: "<< rt <<endl;
                                rt=defineRegistrador(rt);
                                cout << "registrador: "<< rt <<endl;

                                i++;


                                rs=separarPalavra(line[j].instrucao, &i);
                                cout << "registrador: "<< rs <<endl;
                                rs=defineRegistrador(rs);
                                cout << "registrador: "<< rs <<endl;
                                //offset

                                i++;

                                    immed=separarPalavra(line[j].instrucao, &i);
                                if(nome=="sll" || nome=="sra" || nome=="srl")
                                {
                                    funct=defineFunct(word);
                                    shamt=defineShamt(immed);
                                    linha = op + "00000" + rs + rt + shamt + funct;
                                }
                                else
                                {

                                    immed=defineImmed(immed);
                                    linha = op + rs + rt + immed;
                                }

                        }
                        else
                            if(tipo==4) //tipo branch
                            {
                                    op=defineOP(stringHash(nome));

                                    cout << "op: "<< op<<endl;
                                    i++;

                                    rs=separarPalavra(line[j].instrucao, &i);
                                    cout << "registrador: "<< rs <<endl;
                                    rs=defineRegistrador(rs);

                                    cout << "registrador: "<< rs <<endl;

                                    i++;
                                    rt=separarPalavra(line[j].instrucao, &i);

                                    cout << "registrador: "<< rt <<endl;
                                    rt=defineRegistrador(rt);
                                    cout << "registrador: "<< rt <<endl;

                                    i++;

                                    immed=separarPalavra(line[j].instrucao, &i);

                                    cout << "label: "<< immed <<endl;

                                    if(procuraLabel(line,immed,&endereco)) //procura o label
                                     {

                                         endereco=endereco-line[j].endereco-1;

                                     cout << endereco << endl;
                                    //immed=conversor(endereco);
                                    //endereco = (endereco label - endereco atual  -4)/4;
                                        immed=conversor(endereco,16);

                                     cout << immed << endl;


                                        linha = op + rs + rt + immed;

                                    }
                                    else
                                            cout << "Intru��o de endere�o " << j << " est� com erro no label." << endl;

                            }
                            else


                            if(tipo==5) //tipo jump
                                {

                                    op=defineOP(stringHash(nome));

                                    cout << "op: "<< op<<endl;
                                    i++;

                                    rs=separarPalavra(line[j].instrucao, &i);
                                    cout << "registrador: "<< rs <<endl;

                                    if(nome == "jr")
                                    {
                                        rs=defineRegistrador(rs);
                                        cout << "registrador: "<< rs<<endl;
                                        linha = op + rs + "000000000000000001000";
                                    }
                                    else
                                    {
                                        immed = rs;
                                        if(procuraLabel(line,immed,&endereco)) //procura o label
                                        {

                                            cout << endereco << endl;
                                            immed=conversor(endereco,26);

                                            cout << immed <<endl;

    //                                        endAtual=conversor(line[j].endereco);
    /*
                                            cout << endAtual <<endl;
                                            while(endAtual.length()!=32)
                                                endAtual=endAtual+"0";
                                            cout << endAtual <<endl;
                                            */

                                         /*   endAtual = "00000000010000000000000000100000";
                                            int w;
                                            for(w=4; w<endAtual.length();w++)
                                                endAtual[w]='0';

                                            cout << endAtual <<endl;
                                            for(w=0; w<endAtual.length();w++)
                                                if(endAtual[w]=='1' || immed[w]=='1')
                                                    immed[w]='1';
                                                else
                                                    immed[w]='0';


                                            string target;*/



                                            linha = op + immed;
                                        }
                                        else
                                            cout << "Intru��o de endere�o " << j << " est� com erro no label." << endl;
                                }
                                }
                                else
                                {
                                    if (nome == "noop")
                                        linha = "00000000000000000000000000000000";
                                    else
                                    if(nome == "syscall")
                                        linha = "00000000000000000000000000001100";
                                   // else
                                     //   cout << "Instru��o da linha "<<i+1<< " est� incorreta!" <<endl;
                                }

                            cout << "linha: "<<linha <<endl;
          /*     cout << "intrucao: "<< teste<<endl;
                arquivo_out << teste;
                teste=defineRegistrador(word);
                cout<<"registrador: "<<teste << endl;
                int teste1=procuraLabel(line,word);
                cout<<"label no endereco: "<<teste1 <<endl;*/
            }
         cout << "\n" <<endl;
         if(linha!=".")
            arquivo_out << linha <<endl;
        }
	arquivo_out.close();
    getchar();
    return 0;
}


