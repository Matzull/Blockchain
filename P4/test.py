import random

lista_numero= []
longitud_lista=int(input("¿Qué longitud quieres que tenga la lista?"))
inf=int(input("Establece el intervalo inferior"))
sup=int(input("Establece el intervalo superior"))

def fill_list():
  if len(lista_numero) < longitud_lista:
    numero=random.randint(inf,sup)
    lista_numero.append(numero)
    fill_list()
  else:
    return lista_numero
fill_list()

def ordenar_lista_dicotomia(lista_numero):
  for i in range(len(lista_numero)):
    for j in range(i, len(lista_numero)):
      if lista_numero[i] > lista_numero[j]:
        lista_numero[i], lista_numero[j] = lista_numero[j], lista_numero[i]
  print(f"La lista ordenada con una sola tabla es esta: \n {lista_numero}")

ordenar_lista_dicotomia(lista_numero)

lista1= []
lista2 = []
listafinal = []
cota_sup=len(lista_numero)
numero_medio=(cota_sup)// 2

def dicotomia(numero_medio):
  if numero_medio > 0:
    lista1.append(lista_numero.pop(numero_medio))
    dicotomia(numero_medio-1)
  if numero_medio == 0 and len(lista_numero) > 0:
    lista2.append(lista_numero.pop(numero_medio))
    dicotomia(numero_medio)
dicotomia(numero_medio)

listafinal=listafinal+ lista1 + lista2
print(f"\n La lista final con dicotomía es: \n {listafinal}")