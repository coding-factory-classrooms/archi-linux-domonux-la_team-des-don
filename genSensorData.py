#!/usr/bin/python3

import fileinput
import sys
from random import randint

#on génère un message de sortie standart
def generate_value():
    #variable globale pour éviter de la déclarer en dehors de la fonction
    global list_rooms
    list_rooms = {
        1: "Kitchen", 
        2: "Bathroom", 
        3: "Bedroom", 
        4: "Lounge"
    }
    room = randint(1, 4)
    min_value = randint(11, 17)
    max_value = randint(20, 25)

    #on print le message qui contient l'id du capteur, le nom de la pièce, la temp minimale, maximale et une moyenne
    print("Sensor_id: "+str(room)+"; "+str(list_rooms[room])+"; min_value="+str(min_value)+"; max_value="+str(max_value)+"; value="+str((min_value+max_value)/2)+";", flush=True)

#on génère un message d'erreur
def generate_error():
    list_errors = {
        1: [26, "0x8A72E33", "device lost"],
        2: [27, "0x9027Y6G", "Connection lost"],
        3: [28, "0x8042HN1", "Division by zero"]
    }
    err_nbr = randint(1, 3)
    error_id = str(list_errors[err_nbr][0])
    error_code = str(list_errors[err_nbr][1])
    error_desc = list_errors[err_nbr][2]

    #on print le message d'erreur qui contient l'id de l'erreur, le nom de la pièce, le code de l'erreur et sa description
    print("Error#"+error_id+" Room: "+list_rooms[randint(1, 4)]+" code="+error_code+", "+error_desc, file=sys.stderr, flush=True)

#on reçoit l'entrée standart et on la traite
def start():
    print("welcome to the sensor monitoring !\n")
    for line in fileinput.input():
        value = line.rstrip()
        if value == "ERROR":
            generate_error()
        else:
            generate_value()


#on démarre le programme
if __name__ == "__main__":
    start()







