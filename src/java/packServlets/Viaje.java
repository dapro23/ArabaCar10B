/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package packServlets;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class Viaje {

    private String nombre;
    private String id;
    private String conductor;
    private String origen;
    private String destino;
    private LocalDateTime fecha;
    private LocalDateTime fecha2;
    //private String hora;
    private double precio;
    //private LocalDateTime creationDate;
    private Timestamp ola;
    
    //Email y Fecha
    public Viaje(String id, Timestamp fecha) {
        
        this.id = id;
        this.fecha = fecha.toLocalDateTime();       
    }

    
    //Viaje comun      
    public Viaje(String origen, String destino, Timestamp fecha, double precio) {

        this.origen = origen;
        this.destino = destino;
        this.fecha = fecha.toLocalDateTime();
        this.precio = precio;
    }

    
    //Id => mas viaje comun
    public Viaje(String conductor, String origen, String destino, Timestamp fecha, double precio) {

        this.conductor = conductor;
        this.origen = origen;
        this.destino = destino;
        this.fecha = fecha.toLocalDateTime();
        this.precio = precio;
    }

    
    //String String y lo demas
    public Viaje(String id, String conductor, String origen, String destino, Timestamp fecha, double precio) {

        this.id = id;
        this.conductor = conductor;
        this.origen = origen;
        this.destino = destino;
        this.fecha = fecha.toLocalDateTime();
        this.precio = precio;
    }

    
    public Viaje(String id, String nombre, String conductor, String origen, String destino, Timestamp fecha, double precio) {

        this.id = id;
        this.nombre = nombre;
        this.conductor = conductor;
        this.origen = origen;
        this.destino = destino;
        this.fecha = fecha.toLocalDateTime();
        this.precio = precio;
    }
    
    public Viaje(String id, String nombre, String conductor, String origen, String destino, Timestamp fecha, Timestamp fecha2, double precio) {

        this.id = id;
        this.nombre = nombre;
        this.conductor = conductor;
        this.origen = origen;
        this.destino = destino;
        this.fecha = fecha.toLocalDateTime();
        this.fecha2 = fecha2.toLocalDateTime();
        this.precio = precio;
    }
    
    public String getId() {
        return id;
    }

    public String getConductor() {
        return conductor;
    }
    
    public String getNombre() {
        return nombre;
    }

    public String getOrigen() {
        return origen;
    }

    public String getDestino() {
        return destino;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public LocalDateTime getFecha2() {
        return fecha2;
    }
    
    public double getPrecio() {
        return precio;
    }

    void add(Viaje viaje) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

}
