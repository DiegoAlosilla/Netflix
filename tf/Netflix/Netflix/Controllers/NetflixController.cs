using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Netflix.DAO;

namespace Netflix.Controllers
{
    public class NetflixController : Controller
    {
        private DaoPeliculas dao;
        public NetflixController()
        {
            this.dao = new DaoPeliculas();
        }

        // GET: Netflix
        public ActionResult Index()
        {
            var peliculas = dao.GetAll();
            return View(peliculas); 
        }

        // GET: Recomendadas
        public ActionResult Recomendar()
        {
            var peliculas = dao.GetRecomend();
            return View(peliculas);
        }

        // GET: Netflix/Details/5
        public ActionResult Agregar(int id)
        {
            dao.addMovie(id);
            return RedirectToAction("Index");
        }

        // GET: Netflix/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Netflix/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(IFormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: Netflix/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: Netflix/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: Netflix/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: Netflix/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }
    }
}