vm-ansible.tf = infra que cria uma máquina com ansible instalado 
(este contorno foi necessário pois estou utilizando windows e ansible nao roda em windows, se eu tivesse utilizando linux entao eu instalaria ansible no meu linux invés de subir uma máquina para isso.)


main.tf = infra que cria a máquina de produção


dentro da pasta ansible tem os arquivos com a receita para o ansible configurar a máquina de produção, 


inventario = informa qual o ip da máquina que precisa ser configurado


playbook.yaml = informa como configurar e quais softwares instalar


dessa forma a máquina ansible dispara comandos para a máquina de produção configurando ela.