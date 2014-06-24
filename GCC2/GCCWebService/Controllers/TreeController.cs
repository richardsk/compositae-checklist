using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
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
        public List<TreeNode> branch { get; set; }
    }

    public class TreeController : ApiController
    {
        private string GetStartingNode()
        {
            return System.Configuration.ConfigurationManager.AppSettings.Get("StartingNode");
        }

        //
        // GET: /Tree/
        
        public List<TreeNode> Get()
        {
            var da = new WebDataAccess.DaTrees();
            da.DaInitialise(ConfigurationManager.ConnectionStrings["compositae"].ConnectionString);
            var rootKey = GetStartingNode();
            var rootName = ChecklistDataAccess.NameData.GetName(null, rootKey);
            var children = ChecklistDataAccess.NameData.GetChildNames(rootKey, false);
            
            var response = new List<TreeNode>
            {
                new TreeNode
                {
                    id = rootName.Id,
                    label = rootName.NameCanonical,
                    inode = true,
                    open = true,
                    branch = new List<TreeNode>()
                }
            };

            foreach (DataRow row in children.Tables[0].Rows)
            {
                response[0].branch.Add(new TreeNode
                {
                    id = row["NameGuid"].ToString(),
                    label = row["NameCanonical"].ToString(),
                    inode = true,
                    open = false
                });
            }

            return response;

            //return new List<TreeNode>
            //{
            //    new TreeNode
            //    {
            //        id = "1", label = "Compositae", inode=true, open=false,
            //        branch = new List<TreeNode>
            //        {
            //            new TreeNode
            //            {
            //                id="2", label="Eupatroium", inode=true, open=false
            //            }
            //        }
            //    }
            //};
        }

    }
}
