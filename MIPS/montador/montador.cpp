//LABEL TEM QUE FICAR NA MESMA LINHA DA INSTRUCAO
//MUDOU O PADRAO DO SYSCALL

//referencia utilizada: http://alanhogan.com/asu/assembler.php?source

#include <iostream>
#include <fstream>
#include <string>
#include <stdexcept>
#include <ctype.h>
#include "stdlib.h"
#define tam 256

using namespace std;

struct linha //estrutura utilizada para instrucoes
{
    string instrucao;
    string label;
    int endereco;
};

struct dado //estrutura utilizada para dados
{
    string label;
    string type;
    int endereco;

};

int stringHash(string); //transforma a string em numerico para o switch
string tirarEspacosComeco(string); //elimina os espacos da leitura do arquivo apenas do comeco da linha
string tirarEspacos(string); //elimina espaco entre as palavras da linha
string separarPalavra(string, int*); //separa as palavras da instrução
string defineRegistrador(string, bool*); //definindo o codigo binario dos registradores
linha dividirInstrucao(string); //separa o label da instrucao
dado dividirDado(string); //separa o label do tipo de dado
bool procuraLabel(linha*, string, int*); //procura o label chamado pelo usuario
int defineTipoInstrucao(string); //definindo o tipo da instrucao para ser chamado para estrutura
string defineOP(int, bool*); //definindo o opcode da instrucao
string defineFunct(string, bool*); //definindo o funct da instrucao
string conversor(int, int); //conversor de decimal para binario
string defineImmed(string, bool*); //definindo o imediato
string defineShamt(string); //define shamt de algumas instrucoes
bool temComentario(string, int); //valida algum comentário realizado
void defineDados(dado, int*, ofstream*, string*, bool); //definindo a memória de dados


int main ()
{
    linha line[tam];
    dado data[tam];


    ifstream arquivo_in;
    ofstream arquivo_out;
    ofstream arquivo_dados_out;

    int i=0,j=0;
    int tipo; //define o tipo da instrução
    string nome,op, rs, rt, rd, shamt, funct,immed; //partes das instruções
    int endereco;
    string instrucao;
    string byte; //utilizado para os bytes
    string linha, word, linhafinal;
    char arquivo[100];



    cout << "Entre com o nome do arquivo que deseja (juntamento com a extensao .asm): "<<endl;
    cin >> arquivo;

    arquivo_in.open(arquivo);

   if(arquivo_in.good())
        cout << "\nArquivo acessado com sucesso!" << endl;
    else
    {
        cout << "\nProblemas com o arquivo de entrada!" << endl;
        exit(1);
    }

    arquivo_dados_out.open("data_memory.mif");
    arquivo_out.open("instructions_memory.mif");

    arquivo_dados_out << "WIDTH=32;\nDEPTH=256;\n\nADDRESS_RADIX=UNS;\nDATA_RADIX=BIN;\n\nCONTENT BEGIN" <<endl;
    arquivo_out << "WIDTH=32;\nDEPTH=256;\n\nADDRESS_RADIX=UNS;\nDATA_RADIX=BIN;\n\nCONTENT BEGIN" <<endl;


    int tamanho;
    bool ok=true;
    int indice_dado=0;
    int enderecoDado=0;
    int temp;

//lendo o arquivo que foi aberto
	while(!arquivo_in.eof())
	{
        getline(arquivo_in ,linha);

        linha=tirarEspacosComeco(linha);
        int found = linha.find(".data");

        if(found!=-1 && linha[0]!='#')
        {

            while (linha.find(".text")==-1 && !arquivo_in.eof()) //salva todos os .data
            {

                getline(arquivo_in,linha);

                if(linha!="\0" && linha[0]!= '#')
                {
                    data[indice_dado] = dividirDado(linha);
                    indice_dado++;

                }
            }

        }

        if(linha.find(".text")==-1 && linha != "\0" && linha[0]!= '#')
        {
            line[i]=dividirInstrucao(linha);
            line[i].endereco=i;
            line[i].label=tirarEspacos(line[i].label);
            i++;
        }
	}

    tamanho = i-1;
	bool acabou=true;

	for(j=0; j<indice_dado; j++)  //percorrendo os dados
	{              //data[indice_dado].endereco = indice_dado;
        acabou=true;


        data[j].label = tirarEspacos(data[j].label);

        data[j].type = tirarEspacosComeco(data[j].type);

        defineDados(data[j], &enderecoDado, &arquivo_dados_out, &byte, false);


        for(i=j+1; i<indice_dado;i++)
        {
            if(data[i].type.find(".byte")!=-1)
                acabou = false;
        }

        if(acabou)
            defineDados(data[j], &enderecoDado, &arquivo_dados_out, &byte, acabou);


    }



        for(j=0; j<=tamanho;j++)
        {

            for(i=0; i<line[j].instrucao.length();i++)
            {
                word = separarPalavra(line[j].instrucao, &i);
                tipo = defineTipoInstrucao(word);

                nome = word; //esta é o nome da instrução
                if(tipo == 1)//instrução do tipo R
                {
                    i++;
                    op=defineOP(tipo, &ok);

                    rd=separarPalavra(line[j].instrucao, &i);
                    rd=defineRegistrador(rd,&ok);

                    i++;
                    if(word == "mfhi" || word == "mflo")
                    {
                        rs = "00000";
                        rt = "00000";
                    }
                    else
                    {
                        rs=separarPalavra(line[j].instrucao, &i);
                        rs=defineRegistrador(rs,&ok);

                        i++;
                        rt=separarPalavra(line[j].instrucao, &i);
                        rt=defineRegistrador(rt,&ok);
                    }

                    shamt="00000";

                    funct = defineFunct(nome,&ok);
                    if(funct == "011010" || funct == "011011" || funct == "011000" || funct == "011001") //formato ins $s, $t ex: mult, div,divu
                        linha = op +  rd + rs+ "00000" + shamt + funct;
                    else
                        if (funct == "000100" || funct == "000110")
                            linha = op + rt + rs + rd + shamt +funct;
                        else
                            linha = op +  rs + rt+ rd + shamt + funct;

                }
                else
                    if(tipo==2) //tipo I
                    {
                        i++;

                        op=defineOP(stringHash(nome), &ok);



                        rt=separarPalavra(line[j].instrucao, &i);
                        rt=defineRegistrador(rt,&ok);

                        i++;

                        //offset

                        immed=separarPalavra(line[j].instrucao, &i);
                        if(tolower(immed[0])>97 && tolower(immed[0])<122)
                        {
                            bool ok2=false;
                            int a;
                            while(!ok2 && a<indice_dado)
                            {

                                if(immed==data[a].label)
                                {
                                    ok2=true;
                                    immed = conversor(data[a].endereco,16);
                                }
                                else
                                {
                                    ok2=false;

                                }
                                a++;
                            }

                            if(!ok2)
                                   cout << "Intrução de endereço " << j << " está com erro no label." << endl;
                            ok=ok2;
                        }
                        else
                        {
                            immed=defineImmed(immed,&ok);
                           // cout << "immed: "<< immed <<endl;


                        }
                        i++;

                            rs=separarPalavra(line[j].instrucao, &i);
                          //  cout << "aquiregistrador: "<< rs <<endl;
                            rs=defineRegistrador(rs,&ok);

                        linha = op + rs + rt + immed;
                    }
                    else
                        if(tipo==3) //tipo I estilo addi
                        {
                                i++;

                                op=defineOP(stringHash(nome),&ok);

                         //       cout << "op: "<< op<<endl;


                                rt=separarPalavra(line[j].instrucao, &i);
//                                cout << "registrador: "<< rt <<endl;
                                rt=defineRegistrador(rt,&ok);
  //                              cout << "registrador: "<< rt <<endl;

                                i++;


                                rs=separarPalavra(line[j].instrucao, &i);
    //                            cout << "registrador: "<< rs <<endl;
                                rs=defineRegistrador(rs,&ok);
      //                          cout << "registrador: "<< rs <<endl;
                                //offset

                                i++;

                                    immed=separarPalavra(line[j].instrucao, &i);
                                if(nome=="sll" || nome=="sra" || nome=="srl")
                                {
                                    funct=defineFunct(word,&ok);
                                    shamt=defineShamt(immed);
                                    linha = op + "00000" + rs + rt + shamt + funct;
                                }
                                else
                                {

                                    immed=defineImmed(immed,&ok);
                                    linha = op + rs + rt + immed;
                                }

                        }
                        else
                            if(tipo==4) //tipo branch
                            {
                                    op=defineOP(stringHash(nome),&ok);
                                    i++;

                                    rs=separarPalavra(line[j].instrucao, &i);
                                    rs=defineRegistrador(rs,&ok);


                                    i++;
                                    if (nome == "bgez")
                                        rt = "00001";
                                    else
                                        if(nome == "bgezal")
                                            rt = "10001";
                                        else
                                        if (nome == "bltzal")
                                            rt = "10000";
                                        else
                                            if(nome == "bgtz" || nome == "blez" || nome == "bltz")
                                                rt = "00000";
                                            else
                                            {
                                                rt=separarPalavra(line[j].instrucao, &i);
                                                rt=defineRegistrador(rt,&ok);

                                                i++;
                                            }
                                    immed=separarPalavra(line[j].instrucao, &i);

                                    if(procuraLabel(line,immed,&endereco)) //procura o label
                                     {

                                         endereco=endereco-line[j].endereco-1;

                                        immed=conversor(endereco,16);



                                        linha = op + rs + rt + immed;

                                    }
                                    else
                                            cout << "Intrução de endereço " << j << " está com erro no label." << endl;

                            }
                            else


                            if(tipo==5) //tipo jump
                                {

                                    op=defineOP(stringHash(nome),&ok);
                                    i++;

                                    rs=separarPalavra(line[j].instrucao, &i);

                                    if(nome == "jr")
                                    {
                                        rs=defineRegistrador(rs,&ok);
                                        linha = op + rs + "000000000000000001000";
                                    }
                                    else
                                    {
                                        immed = rs;
                                        if(procuraLabel(line,immed,&endereco)) //procura o label
                                        {

                                            immed=conversor(endereco,26);

                                            linha = op + immed;
                                        }
                                        else
                                            cout << "Intrução de endereço " << j << " está com erro no label." << endl;
                                }
                                }
                                else if(tipo == 6)
                                {
                                    if (nome == "noop")
                                        linha = "00000000000000000000000000000000";
                                    else
                                    if(nome == "syscall")
                                        linha = "000000"+defineRegistrador("$v0",&ok)+defineRegistrador("$a0",&ok)+"0000000000001100";
                                   // else
                                     //   cout << "Instrução da linha "<<i+1<< " está incorreta!" <<endl;
                                }
                                else if(tipo==7)
                                {
                                        i++;
                                        rd=separarPalavra(line[j].instrucao, &i);
                                        rd=defineRegistrador(rd,&ok);

                                        i++;

                                        immed = separarPalavra(line[j].instrucao, &i);
                                        immed=defineImmed(immed,&ok);

                                        //transformamos para addi
                                        rs = "00000";
                                        linha = "001000" + rs + rd + immed;


                                }
                                else
                                {
                                    ok=false;
                                    i = line[j].instrucao.length();
                                }
                if(temComentario(line[j].instrucao,i))
                {
                   instrucao=line[j].instrucao.substr(0,i+1);
                   instrucao=tirarEspacosComeco(instrucao);
                   i=line[j].instrucao.length();

                }
                else
                {
                    instrucao=line[j].instrucao.substr(0,line[j].instrucao.length());
                    instrucao=tirarEspacosComeco(instrucao);
                }
            }
         temp = j;
         if(ok)
         {
            arquivo_out<<"\t" << line[j].endereco << " : " << linha << ";\t--\t"<< instrucao <<endl;
         }
         else
         {
            cout << "Instrução da linha "<<j<< " está incorreta!" <<endl;

            j=tamanho;
         }
        }
    if (ok)
    {
        cout << "\n\nPROGRAMA COMPILADO COM SUCESSO!" << endl;

    }
    else
    {
        cout << "\n\nPROGRAMA COM ERRO!" << endl;
    }


    arquivo_out << "\t["<<temp<<"..255] : 00000000000000000000000000000000;" << endl;
    arquivo_dados_out << "\t["<<enderecoDado<<"..255] : 00000000000000000000000000000000;" << endl;
    arquivo_out << "END;"<< endl;
    arquivo_dados_out << "END;"<<endl;
    arquivo_dados_out.close();
    arquivo_out.close();
    return 0;
}

int stringHash(string word)
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

string tirarEspacosComeco(string word)
{
    int i=0;
    int j;
    bool mudou = false;
    int tamanho=word.length();

        string aux;
    if(word[i]==' ')
        while(i<tamanho)
        {
                if(word[i]==' ')
                {
                    for(j=i;j<word.length();j++)
                        word[j]=word[j+1];
                    mudou = true;
                    tamanho--;
                    i=tamanho;
                }
                i++;
        }
    else
        aux=word;

        word[i]='\0';
        i=0;
        if(mudou)
        while(word[i]!='\0')
        {
            aux+=word[i];
            i++;
        }

    return aux;
}

string tirarEspacos(string word)
{
    int i=0;
    int j;
    int tamanho=word.length();
    while(i<tamanho)
    {
            if(word[i]==' ' || word[i]==':')
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

    while (isspace(line[*i]) || line[*i]=='(' ||  line[*i]==')' || line[*i]==',' ||  line[*i]==':')
        *i=*i+1;

    while(line[*i]!='(' &&  line[*i]!=')' && line[*i]!=',' &&  line[*i]!=':' && !isspace(line[*i]) && line[*i]!='\0')
    {
        word+=line[*i];
        *i=*i+1;
    }

    word = tirarEspacos(word);

    return word;

}

string defineRegistrador(string word, bool *ok)
{
    string saida="erro";
    if(word == "$zero" || word =="$0" )
        saida= "00000";//0
    else
        if(word == "$v0")
            saida= "00010"; //2
        else
            if(word == "$v1")
                saida= "00011";
            else
                if(word == "$a0")
                    saida = "00100";
                else
                    if(word == "$a1")
                        saida = "00101";
                    else
                        if(word == "$a2")
                            saida = "00110";
                        else
                            if(word == "$a3")
                                saida = "00111";
                            else
                                if(word == "$t0")
                                    saida = "01000";
                                else
                                    if(word == "$t1")
                                        saida = "01001";
                                    else
                                        if(word == "$t2")
                                            saida = "01010";
                                        else
                                            if(word == "$t3")
                                                saida = "01011";
                                            else
                                                if(word == "$t4")
                                                    saida = "01100";
                                                else
                                                    if(word == "$t5")
                                                        saida = "01101";
                                                    else
                                                        if(word == "$t6")
                                                            saida = "01110";
                                                        else
                                                            if(word == "$t7")
                                                                saida = "01111";
                                                            else
                                                                if(word == "$s0")
                                                                    saida = "10000";
                                                                else
                                                                    if(word == "$s1")
                                                                        saida = "10001";
                                                                    else
                                                                        if(word == "$s2")
                                                                            saida = "10010";
                                                                        else
                                                                            if(word == "$s3")
                                                                                saida = "10011";
                                                                            else
                                                                                if(word == "$s4")
                                                                                    saida = "10100";
                                                                                else
                                                                                    if(word == "$s5")
                                                                                        saida = "10101";
                                                                                    else
                                                                                        if(word == "$s6")
                                                                                            saida = "10110";
                                                                                        else
                                                                                            if(word == "$s7")
                                                                                                saida = "10111";
                                                                                            else
                                                                                                if(word == "$t8")
                                                                                                    saida = "11000";
                                                                                                else
                                                                                                    if(word == "$t9")
                                                                                                        saida = "11001";
                                                                                                    else
                                                                                                        if(word == "$k0")
                                                                                                            saida = "11010";
                                                                                                        else
                                                                                                            if(word == "$k1")
                                                                                                                saida = "11011";
                                                                                                            else
                                                                                                                if(word == "$gp")
                                                                                                                    saida = "11100";
                                                                                                                else
                                                                                                                    if(word == "$sp")
                                                                                                                        saida = "11101";
                                                                                                                    else
                                                                                                                        if(word == "$fp")
                                                                                                                            saida = "11110";
                                                                                                                        else
                                                                                                                            if(word == "$ra")
                                                                                                                                saida = "11111";


            if(saida!= "erro" && *ok)
                *ok=true;
            else
                *ok=false;

            return saida; //quando não for nenhum dos registradores
                                                            //colocar o resto da tabela quando passar pra tcl
}

linha dividirInstrucao(string word)
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

dado dividirDado(string word)
{
    dado aux1;
    int i=0;
    int j=0;
    int tamanho=word.length();

    while(i<tamanho)
    {
            if(word[i]==':')
            {
                j=i+1;
                i=tamanho;
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
        aux1.type=aux2;
    }
    else
        aux1.type=word;

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
    || word == "mflo" || word == "mult" || word=="multu" || word == "sllv" || word == "srlv") //colocar instruções do tipo r;
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
    else if (word == "syscall" || word == "noop")
        return 6;
    else if (word == "move")
        return 7;

        return 0;



}

string defineOP(int word, bool *ok)
{
    string saida="erro";
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
            if(saida!="erro" && *ok)
                *ok=true;
            else
                *ok=false;
            return saida;

}

string defineFunct(string word, bool *ok)
{
    string saida="erro";

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

            if(saida!="erro" && ok)
                *ok=true;
            else
                *ok=false;

    return saida;

}

string conversor(int numero, int quantidade) //converte de decimal para binário
{
    string bin;
    int numero_abs = abs(numero);


        while (numero_abs > 0)
        {
            if(numero_abs%2==0)
                bin="0" + bin ;
            else
                bin="1" + bin;

            numero_abs=numero_abs/2;
        }
  //      cout << numero << ".teste: " << bin << ". tamanho " << bin.length() <<endl;
        while (bin.length()<quantidade)
            bin="0"+bin;

        if (numero < 0)
        {
            int i=0;
            while(i<quantidade)
            {
                if(bin[i]=='0')
                    bin[i]='1';
                else
                    bin[i]='0';
                i++;

            }
            i=quantidade;
            bool mudou=false;
            while(!mudou)
            {
                i--;
                if(bin[i]=='0')
                {
                    bin[i]='1';
                    mudou = true;
                }
                else
                {
                    bin[i]='0';
                    mudou = false;

                }
            }


        }
        return bin;

}

string defineImmed(string word, bool *ok)
{
    int immed;
    string imm="erro";

    immed = atoi( word.c_str());
    imm = conversor(immed,16);


    if(imm!="erro" && *ok)
        *ok=true;
    else
        *ok=false;

    return imm;
}

string defineShamt(string word)
{
    int shamt;
    string sham;

    shamt = atoi( word.c_str());
    sham = conversor(shamt,5);


    return sham;
}

bool temComentario(string linha, int i)
{

    for(i=0; i<linha.length(); i++)
        if(linha[i]=='#')
            return true;

    return false;

}

void defineDados(dado aux1, int *ultimoEnd, ofstream *arquivo_dados_out, string *byte, bool acabou)
{
    int i=0;
    int num;
    int tipo=0;
    string word, end;

    word=separarPalavra(aux1.type,&i);

    if(word == ".word")
        tipo = 1;
    else
        if(word == ".byte")
            tipo = 2;

    bool sair = false;

    if(tipo==1)
    {
        i++;

        while(aux1.type[i]!= '\0' && !sair && !acabou)
        {

            word = separarPalavra(aux1.type,&i);
            if(word!="#")
            {
                num = atoi(word.c_str());
                word = conversor(num,32);

                aux1.endereco=*ultimoEnd;
                *arquivo_dados_out << "\t"<< aux1.endereco << " : " << word << ";" <<endl;

                *ultimoEnd=*ultimoEnd+1;

            }
            else
                sair = true;
            i++;

         }


    }
    else
        if(tipo==2)
        {

            while(aux1.type[i]!= '\0' && !sair && aux1.type.length()>=i && !acabou)
            {

                if(aux1.type[i]>47 && aux1.type[i]<58)
                {
                    word = separarPalavra(aux1.type,&i);
                    if(word!="#")//correspondentes da tabela ASCII
                    {
                        num = atoi(word.c_str());
                        if(byte->length()==32)
                        {
                            aux1.endereco=*ultimoEnd;
                            *arquivo_dados_out << "\t"<< aux1.endereco << " : " << *byte << ";" <<endl;
                            *ultimoEnd=*ultimoEnd+1;

                             word=conversor(num,8);
                            *byte = word;
                        }
                        else
                        {
                            word=conversor(num,8);
                            *byte=word+*byte;
                        }


                    }
                    else
                        sair = true;
                    i++;
                }
                else
                    i++;
            }

            if(byte->length()<32 && acabou)
            {

                aux1.endereco=*ultimoEnd;

                while(byte->length()<32)
                {
                    *byte="0"+*byte;

                }

                *arquivo_dados_out << "\t"<< aux1.endereco << " : " << *byte << ";" <<endl;
                *ultimoEnd=*ultimoEnd+1;
            }


        }

}
