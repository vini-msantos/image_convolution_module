Para rodar uma transformação de imagem: 
1. Basta colocar nessa pasta um arquivo 'input.txt' com o bitmap da imagem (por enquanto o módulo trabalha apenas com um canal de cor).
2. Altere o filtro mudando o valor inicial do sinal 'filter' no arquivo 'filter_module_tb.vhd' para escolher o filtro desejado:

    - "00" -> sem filtro.
    - "01" -> nitidez.
    - "10" -> borrar a imagem.
    - "11" -> detecção de borda. 
3. e execute os comandos no terminal dentro deste diretório:
```bash
    ghdl -i --std=08 *.vhd
```
```bash
    ghdl -m --std=08 filter_module_tb
```

```bash
    ghdl -r filter_module_tb
```
4. A imagem resultante será em bitmap no arquivo 'output.txt'.

OBS: utilize os sites [img2list](https://xeltalliv.github.io/ScratchTools/Img2list/#dc1) e [list2image](https://xeltalliv.github.io/ScratchTools/List2img/#dn0) para fazer a transformação para e de bitmap.