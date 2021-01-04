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
    private String movil;
    private double precio;
    private String coche;

    //Email y Fecha
    public Viaje(String id, Timestamp fecha) {

        this.id = id;
        this.fecha = fecha.toLocalDateTime();
    }

    public Viaje(String id, String nombre, Timestamp fecha) {
        this.id = id;
        this.nombre = nombre;
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
    
    public Viaje(String id, String nombre, String conductor, String movil, String origen, String destino, Timestamp fecha, double precio) {

        this.id = id;
        this.nombre = nombre;
        this.conductor = conductor;
        this.movil = movil;
        this.origen = origen;
        this.destino = destino;
        this.fecha = fecha.toLocalDateTime();        
        this.precio = precio;
    }
    
    public Viaje(String id, String nombre, String conductor, String movil, String coche,String origen, String destino, Timestamp fecha, double precio) {

        this.id = id;
        this.nombre = nombre;
        this.conductor = conductor;
        this.movil = movil;
        this.coche = coche;
        this.origen = origen;
        this.destino = destino;
        this.fecha = fecha.toLocalDateTime();        
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
    
    public String getMovil() {
        return movil;
    }
    
    public String getCoche() {        
        return coche;
    }

    public String getOrigen() {
        return origen;
    }

    public String getDestino() {
        return destino;
    }

    public String getFecha() {
        
        LocalDateTime fechaA = this.fecha;
        
        fechaA = fechaA.plusHours(-1);

        int año = fechaA.getYear();
        int mes = fechaA.getMonthValue();
        int dia = fechaA.getDayOfMonth();

        int horaP = fechaA.getHour();
        //horaP = horaP - 1;
        int minutoP = fechaA.getMinute();

        String hora = ""+horaP;
        String minuto = ""+minutoP;
        
        if (horaP < 10) {
            hora = "0" + hora;
        }

        if (minutoP < 10) {
            minuto = "0" + minuto;
        }

        //int segundo = fecha.getSecond();
        String fechaP = dia + "/" + mes + "/" + año + " " + hora + ":" + minuto;

        return fechaP;
    }

    public String getFecha2() {

        LocalDateTime fechaA = this.fecha2;
        
        fechaA = fechaA.plusHours(-1);

        int año = fechaA.getYear();
        int mes = fechaA.getMonthValue();
        int dia = fechaA.getDayOfMonth();

        int horaP = fechaA.getHour();
        //horaP = horaP - 1;
        int minutoP = fechaA.getMinute();

        String hora = ""+horaP;
        String minuto = ""+minutoP;
        
        if (horaP < 10) {
            hora = "0" + hora;
        }

        if (minutoP < 10) {
            minuto = "0" + minuto;
        }

        //int segundo = fecha.getSecond();
        String fechaP = dia + "/" + mes + "/" + año + " " + hora + ":" + minuto;

        return fechaP;
    }

    public double getPrecio() {
        return precio;
    }

    void add(Viaje viaje) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

}
