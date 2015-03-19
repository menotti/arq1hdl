# Introdução #

Este trabalho consiste em uma implementação simplificada do processador MIPS em sua versão multiciclo para síntese em FPGAs da Altera e Xilinx.

# Instruções #

A seguir são listadas as instruções suportadas pelo processador até o momento.

## LW ##

| Descrição   | Carrega uma _word_ da memória em um registrador especificado |
|:--------------|:--------------------------------------------------------------|
| Operação    | $t = MEM[$s + offset]; advance\_pc(4); |
| Sintaxe     | lw $t, offset($s) |
| Codificação | `1000 11ss ssst tttt iiii iiii iiii iiii` |

## SW ##

| Descrição   | Grava uma _word_ na memória a partir de um registrador especificado |
|:--------------|:---------------------------------------------------------------------|
| Operação    | MEM[$s + offset] = $t; advance\_pc (4); |
| Sintaxe     | sw $t, offset($s) |
| Codificação | `1010 11ss ssst tttt iiii iiii iiii iiii` |

## JR ##

| Descrição   | Pula para o endereço contido no registrador $s |
|:--------------|:------------------------------------------------|
| Operação    | PC = nPC; nPC = $s; |
| Sintaxe     | jr $s |
| Codificação | `0000 00ss sss0 0000 0000 0000 0000 1000` |

## NOOP ##

| Descrição   | Não realiza nenhuma operação |
|:--------------|:--------------------------------|
| Operação    | advance\_pc(4); |
| Sintaxe     | noop |
| Codificação | `0000 0000 0000 0000 0000 0000 0000 0000` |
| Observação  | A codificação do NOOP é equivalente a instrução SLL $0, $0, 0 |

## SLL ##

| Descrição   | Desloca o valor do registrador $t para esquerda "h" vezes e armazena o resultado no registrador $d |
|:--------------|:---------------------------------------------------------------------------------------------------|
| Operação    | $d = $t<<h; advance\_pc(4); |
| Sintaxe     | sll $d, $t, h |
| Codificação | `0000 00ss ssst tttt dddd dhhh hh00 0000` |

## ORI ##

| Descrição   | Faz a operação OR bit a bit com um registrador e um valor imediato e armazena o resultado em um registrador |
|:--------------|:--------------------------------------------------------------------------------------------------------------|
| Operação    | $t = $s OR imm; advance\_pc(4); |
| Sintaxe     | ori $t, $s, imm |
| Codificação | `0011 01ss ssst tttt iiii iiii iiii iiii` |

## SLTI ##

| Descrição   | Se $s for menor que o imediato, $t recebe 1, senão $t recebe 0 |
|:--------------|:----------------------------------------------------------------|
| Operação    | if $s < imm $t = 1; advance\_pc (4); else $t = 0; advance\_pc (4); |
| Sintaxe     | slti $t, $s, imm |
| Codificação | `0010 10ss ssst tttt iiii iiii iiii iiii` |

## SB ##
| Descrição   | O byte menos significativo de $t é armazenado no endereço especificado |
|:--------------|:-------------------------------------------------------------------------|
| Operação    | MEM[$s + offset] = (0xff & $t); advance\_pc (4); |
| Sintaxe     | sb $t, offset($s) |
| Codificação | `1010 00ss ssst tttt iiii iiii iiii iiii` |

## ADDI ##
| Descrição   | Adiciona em um registo o valor de outro registrador acrescentado o valor do imediato |
|:--------------|:-------------------------------------------------------------------------------------|
| Operação    | $t = $s + imm; else advance\_pc (4); |
| Sintaxe     | addi $t, $s, imm |
| Codificação | `0010 00ss ssst tttt iiii iiii iiii iiii` |

## ANDI ##
| Descrição   | Realiza o and bit a bit do valor do registrador especificado com o offset |
|:--------------|:--------------------------------------------------------------------------|
| Operação    | $t = $s & imm; advance\_pc (4); |
| Sintaxe     | andi $t, $s, imm |
| Codificação | `0011 00ss ssst tttt iiii iiii iiii iiii` |

## BNE ##
| Descrição   | Efetua uma função de branch se os registradores não forem iguais |
|:--------------|:--------------------------------------------------------------------|
| Operação    | if $s != $t advance\_pc (offset << 2); else advance\_pc (4); |
| Sintaxe     | bne $s, $t, offset |
| Codificação | `0001 01ss ssst tttt iiii iiii iiii iiii` |

## JAL ##
| Descrição   | Pula para a instrução do imediato especificado e guarda o endereço de retorno em $31 |
|:--------------|:----------------------------------------------------------------------------------------|
| Operação    | $31 = PC + 8 (or nPC + 4); PC = nPC; nPC = (PC & 0xf0000000) | (target << 2); |
| Sintaxe     | jal target |
| Codificação | `0000 11ii iiii iiii iiii iiii iiii iiii` |

## JALR ##
| Descrição   | Armazena a posição do PC atual no registrador $31, e em seguida efetua uma função jump para o conteúdo do registrador $s |
|:--------------|:------------------------------------------------------------------------------------------------------------------------------|
| Operação    | $31 = pc; pc = $s |
| Sintaxe     | jalr $s |
| Codificação | `0000 00ss sss0 0000 0000 0000 0000 1001` |

## SUB ##
| Descrição   | Subtrai o valor de dois registradores e salva o resultado em um registrador |
|:--------------|:----------------------------------------------------------------------------|
| Operação    | $d = $s - $t; advance\_pc (4); |
| Sintaxe     | sub $d, $s, $t |
| Codificação | `0000 00ss ssst tttt dddd d000 0010 0010` |

## AND ##
| Descrição   | Faz a comparação and bit a bit entre dois registradores e armazena o resultado em um registrador |
|:--------------|:---------------------------------------------------------------------------------------------------|
| Operação    | $d = $s & $t; advance\_pc (4); |
| Sintaxe     | and $d, $s, $t |
| Codificação | `0000 00ss ssst tttt dddd d000 0010 0100` |

## BGEZAL ##
| Descrição   | Efetua uma função de branch quando o valor do registrador é maior ou igual a zero |
|:--------------|:-------------------------------------------------------------------------------------|
| Operação    | se $s >= 0 $31 = PC + 8 (or nPC + 4); advance\_pc (offset << 2)); senão advance\_pc (4); |
| Sintaxe     | bgezal $s, offset |
| Codificação | `0000 01ss sss1 0001 iiii iiii iiii iiii` |

## BLTZ ##
| Descrição   | Realiza o branch quando o registrador especificado possui um valor negativo |
|:--------------|:----------------------------------------------------------------------------|
| Operação    | se $s < 0 advance\_pc (offset << 2)); senão advance\_pc (4); |
| Sintaxe     | bltz $s, offset |
| Codificação | `0000 01ss sss0 0000 iiii iiii iiii iiii` |

## LUI ##
| Descrição   | O valor imediato é descolado para a esquerda 16 bits e armazenado no registrador. Os 16 bits mnos significativos são zeros |
|:--------------|:-----------------------------------------------------------------------------------------------------------------------------|
| Operação    | $t = (imm << 16); advance\_pc (4); |
| Sintaxe     | lui $t, imm |
| Codificação | `0011 11-- ---t tttt iiii iiii iiii iiii` |

## OR ##
| Descrição   | Faz a operação OR bit a bit com dois registradores e armazena o resultado em um registrador |
|:--------------|:----------------------------------------------------------------------------------------------|
| Operação    | $d = $s | $t; advance\_pc (4); |
| Sintaxe     | or $d, $s, $t |
| Codificação | `0000 00ss ssst tttt dddd d000 0010 0101` |

## LBU ##
| Descrição   | Carrega um byte da memória em um registrador especificado |
|:--------------|:-----------------------------------------------------------|
| Operação    | $t = MEM[$s + offset]; advance\_pc (4); |
| Sintaxe     | lbu $t, offset($s) |
| Codificação | `1000 00ss ssst tttt iiii iiii iiii iiii` |

## NAND ##
| Descrição   | Faz a comparação nand bit a bit entre dois registradores e armazena o resultado em um registrador |
|:--------------|:----------------------------------------------------------------------------------------------------|
| Operação    | $d = not($s & $t); advance\_pc (4); |
| Sintaxe     | nand $d, $s, $t |
| Codificação | `0000 00ss ssst tttt dddd d000 0010 1101` |

## XOR ##
| Descrição   | Faz a operação XOR bit a bit com dois registradores e armazena o resultado em um registrador |
|:--------------|:-----------------------------------------------------------------------------------------------|
| Operação    | $d = $s ^ $t; advance\_pc (4); |
| Sintaxe     | xor $d, $s, $t |
| Codificação | `0000 00ss ssst tttt dddd d000 0010 0110` |

## BLTZAL ##
| Descrição   | Efetua uma função de branch quando o valor do registrador é menor que zero |
|:--------------|:------------------------------------------------------------------------------|
| Operação    | se $s < 0 $31 = PC + 8 (or nPC + 4); advance\_pc (offset << 2)); senão advance\_pc (4); |
| Sintaxe     | bltzal $s, offset |
| Codificação | `0000 01ss sss1 0000 iiii iiii iiii iiii` |

# Simulação #

## ModelSim ##

A simulação do processador pode ser realizada no ModelSim por meio do _scritp_ do.do na pasta principal do projeto.

# Referências #

  * Vídeo
    * [VGA controller](http://eewiki.net/pages/viewpage.action?pageId=15925278)
    * [VGA text-mode](http://www.javiervalcarce.eu/wiki/VHDL_Macro:_VGA80x40)
  * FPGA
    * Altera
      * [DE1](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=165&No=83)
      * [DE2-115](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=165&No=502)
    * Xilinx
      * [Spartan-3 Starter Kit](http://www.digilentinc.com/Products/Detail.cfm?Prod=S3BOARD)
      * [Virtex II-Pro](http://www.xilinx.com/univ/xupv2p.html)
  * IP Cores
    * [Rapid Prototyping of Digital Systems](http://www.ece.gatech.edu/academic/courses/fpga/Xilinx/)
  * Assembly
    * [MIPS Assembler](http://alanhogan.com/asu/assembler.php)
    * [MARS Simulator](http://courses.missouristate.edu/kenvollmar/mars/)
  * TCL
    * [Tutorial Tcl](http://www.tcl.tk/man/tcl8.5/tutorial/tcltutorial.html)
  * Otimização
    * http://www.altera.com/literature/manual/mnl_sdctmq.pdf
    * http://www.eet.bme.hu/~nagyg/mikroelektronika/TimeQuest_User_Guide.pdf
    * http://www.altera.com/support/examples/timequest/exm-tq-basic-sdc-template.html
    * http://www.ict.kth.se/courses/IL2207/1101/Labs/Lab1/tut_timing_vhdl.pdf
    * http://www.altera.com/literature/ug/ug_tq_tutorial.pdf