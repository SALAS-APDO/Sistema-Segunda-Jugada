import pyodbc
import os

# Mantenemos tu conexión que ya funciona
datos_conexion = (
    "Driver={SQL Server};"
    "Server=DESKTOP-ASMGT95;" 
    "Database=SegundaJugada;" 
    "Trusted_Connection=yes;"
)
def limpiar_pantalla():
    # Esto limpia la consola para que se vea ordenado
    os.system('cls' if os.name == 'nt' else 'clear')

try:
    conexion = pyodbc.connect(datos_conexion)
    cursor = conexion.cursor()

    while True:
        limpiar_pantalla()
        print("*"*40)
        print(">>>SISTEMA POS: SEGUNDA JUGADA $")
        print("*"*41)
        print(" [1] Registrar prenda")
        print(" [2] Ver Stock actual")
        print(" [3] Nueva Venta (Caja)")
        print(" [4] Salir")
        print("-"*41)
        
        opcion = input(" Seleccione una opcion: ")

        if opcion == "1":
            limpiar_pantalla()
            print(">>> REGISTRO DE MERCADERIA")
            nombre = input(" Nombre de prenda: ")
            precio = float(input(" Precio: S/ "))
            estado = input(" Estado (Nuevo/Usado): ")
            
            # Guardamos en la tabla Inventario que ya tienes en SQL
            cursor.execute("INSERT INTO Inventario (prenda, precio, estado) VALUES (?,?,?)", (nombre, precio, estado))
            conexion.commit()
            input("\nExito: Guardado en SQL. Presione Enter para volver...")

        elif opcion == "2":
            limpiar_pantalla()
            print(">>> INVENTARIO EN TIEMPO REAL")
            print("-" * 60)
            # Formateo de columnas para que se vea como una tabla profesional
            print(f"{'ID':<5} | {'PRENDA':<20} | {'PRECIO':<10} | {'ESTADO':<10}")
            print("-" * 60)
            cursor.execute("SELECT id, prenda, precio, estado FROM Inventario")
            for fila in cursor.fetchall():
                print(f"{fila[0]:<5} | {fila[1]:<20} | S/{fila[2]:<8.2f} | {fila[3]:<10}")
            input("\nPresione Enter para volver...")

        elif opcion == "3":
            limpiar_pantalla()
            print(">>> MODULO DE VENTAS (CAJA)")
            total = 0
            while True:
                item = input(" Producto (o 'f' para cobrar): ")
                if item.lower() == 'f': break
                costo = float(input(f" Precio de {item}: S/ "))
                total += costo
            
            bolsa = input(" Desea bolsa? (S/ 0.50 adicionales) S/N: ").upper()
            if bolsa == 'S': total += 0.50

            print(f"\n TOTAL A PAGAR: S/ {total:.2f}")
            doc = input(" Boleta o Factura? (B/F): ").upper()
            num_doc = input(" Numero de Documento (DNI/RUC): ")
            #esto le estoy agregando para guarda en SQL:
            query_venta = "INSERT INTO Ventas (documento_cliente, tipo_comprobante, total_pagado) VALUES (?, ?, ?)"
            cursor.execute(query_venta, (num_doc, doc, total))
            conexion.commit()
            # -----------------------------------

            
            print("\n" + "*"*30)
            print("   OPERACION EXITOSA")
            print("*"*30)
            input("\nPresione Enter para volver...")

        elif opcion == "4":
            print("\nCerrando sistema... Buen trabajo!")
            break
            
    conexion.close()

except Exception as e:
    print(f"Error en el sistema: {e}")
