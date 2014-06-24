using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace GCCWebService.Controllers
{
    public class MapController : ApiController
    {
        // GET api/map
        /// <summary>
        /// Get the default map url
        /// </summary>
        /// <returns></returns>
        public string Get()
        {
            return "http://edit.africamuseum.be/edit_wp5/v1/areas.php?l=earth&ad=tdwg3:a:NONE&as=a:8dd3c7,,1&ms=400&bbox=-180,-90,180,90";
        }

        // GET api/map/nameId
        public string Get(string nameId)
        {
            var da = new WebDataAccess.Distribution();
            var geos = da.GetNameDistributionDescendents(nameId);
            return da.GetMapUrl(geos);
        }

        // POST api/map
        public void Post([FromBody]string value)
        {
        }

        // PUT api/map/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/map/5
        public void Delete(int id)
        {
        }
    }
}