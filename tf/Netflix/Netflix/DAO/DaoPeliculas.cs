using Netflix.Models;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Netflix.DAO
{
    public class DaoPeliculas
    {
        private readonly string connectionString;

        public DaoPeliculas()
        {
            connectionString = "Data Source=.;Initial Catalog=Netflix;Integrated Security=True;Connect Timeout=30;Encrypt=False;";
        }

        public IEnumerable<Pelicula> GetAll()
        {
            List<Pelicula> proyectos = new List<Pelicula>();

            using (SqlConnection sql = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Titles", sql)
                {
                    CommandType = CommandType.Text
                };
                sql.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    proyectos.Add(MapToValue(reader));
                }
                sql.Close();
                return proyectos;
            }
        }


        public IEnumerable<Pelicula> GetRecomend()
        {
            List<Pelicula> proyectos = new List<Pelicula>();

            using (SqlConnection sql = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SP_Peliculas_Recomendadas", sql)
                {
                    CommandType = CommandType.StoredProcedure
                };
                sql.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    proyectos.Add(MapToValue(reader));
                }
                sql.Close();
                return proyectos;
            }
        }


        public void addMovie(int id)
        {
            using (SqlConnection sql = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SP_InsertConsulta", sql);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdMovie", id);
                sql.Open();
                cmd.ExecuteNonQuery();
                sql.Close();
            }
        }

        private Pelicula MapToValue(SqlDataReader reader)
        {
            return new Pelicula()
            {

                IdMovie = (int)reader["IdMovie"],
                Year = (int)reader["Year"],
                Titles = reader["Titles"].ToString(),
            };
        }

    }
}
