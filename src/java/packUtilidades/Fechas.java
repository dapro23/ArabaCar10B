package packUtilidades;
import java.sql.Date;

public class Fechas {

    public static Date convertirADate(String fecha) {
        String yyyy = fecha.substring(6);
        String mm = fecha.substring(3, 5);
        String dd = fecha.substring(0, 2);

        Date date = Date.valueOf(fecha);

        return date;
    }

    public static int compararFechas(Date f1, Date f2) {
        int i = 0;
        if (f1.compareTo(f2) > 0) {
            i = -1;
        } else if (f1.compareTo(f2) < 0) {
            i = 1;
        } else if (f1.compareTo(f2) == 0) {
            i = 0;
        } else {
            System.out.println("algo ha ido mal");
        }
        return i;
    }
}
