using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Http;

namespace GCCWebService.Controllers
{
    public class TreeNode
    {
        public string id { get; set; }
        public string label { get; set; }
        public bool inode { get; set; }
        public bool open { get; set; }

    }

    public class TreeController : ApiController
    {
        //
        // GET: /Tree/
        
        public List<TreeNode> Get()
        {
            return new List<TreeNode> { new TreeNode { id = "1", label = "Compositae", inode=true, open= false } };
            //return new { id = 1, label = "Compositae" };
            //return new JsonResult { Data = "[{\"id\":\"1\",\"label\":\"Compositae\",\"inode\":true,\"open\":false,\"branch\":[{\"id\":\"2\",\"label\":\"Eupatorium\",\"inode\":true}]}]" };
        }

    }
}
