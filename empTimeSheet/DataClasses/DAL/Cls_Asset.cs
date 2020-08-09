using System.Data;
using System.Data.SqlClient;
using empTimeSheet.DataClasses.DAL;
using System.Web;

namespace empTimeSheet.DataClasses.DAL
{
    public class Cls_Asset : clsDAL
    {
        #region "Variables"
        private string _action, _nid, _Code, _name, _companyId;

        private string _CategoryID, _CategoryName, _CategoryDesc, _ParentId, _vendorId, _VendorCode, _VendorName, _ContactPerson, _Designation, _Street, _City, _State,
            _Country, _Zip, _Phone, _Cell, _Email, _Fax, _Website, _Notes,
            _department, _assetDesc, _assetBarcode, _serialNo, _ItemWaranty, _AssetCondition, _manuCompany, _price, _invoice, _creationDate, _modificationdate,
            _currentLocation, _locationId, _cLocation, _cLocationId, _transferTo, _transferToID, _transferBy, _transferDate, _bstatus, _CreatedBy, _AssetId, _dueDate,
            _recType, _PurchaseDate, _imgURL, _from, _to, _status;
        #endregion

        #region Properties
        public string action { get { return this._action; } set { this._action = value.Trim(); } }
        public string nid { get { return this._nid; } set { this._nid = value.Trim(); } }
        public string Code { get { return this._Code; } set { this._Code = value.Trim(); } }
        public string name { get { return this._name; } set { this._name = value.Trim(); } }
        public string companyId { get { return this._companyId; } set { this._companyId = value.Trim(); } }

        public string CategoryID { get { return this._CategoryID; } set { this._CategoryID = value.Trim(); } }
        public string CategoryName { get { return this._CategoryName; } set { this._CategoryName = value.Trim(); } }
        public string CategoryDesc { get { return this._CategoryDesc; } set { this._CategoryDesc = value.Trim(); } }
        public string ParentId { get { return this._ParentId; } set { this._ParentId = value.Trim(); } }
        public string VendorCode { get { return this._VendorCode; } set { this._VendorCode = value.Trim(); } }
        public string VendorName { get { return this._VendorName; } set { this._VendorName = value.Trim(); } }
        public string ContactPerson { get { return this._ContactPerson; } set { this._ContactPerson = value.Trim(); } }
        public string Designation { get { return this._Designation; } set { this._Designation = value.Trim(); } }
        public string Street { get { return this._Street; } set { this._Street = value.Trim(); } }
        public string City { get { return this._City; } set { this._City = value.Trim(); } }
        public string State { get { return this._State; } set { this._State = value.Trim(); } }
        public string Country { get { return this._Country; } set { this._Country = value.Trim(); } }
        public string Zip { get { return this._Zip; } set { this._Zip = value.Trim(); } }
        public string Phone { get { return this._Phone; } set { this._Phone = value.Trim(); } }
        public string Cell { get { return this._Cell; } set { this._Cell = value.Trim(); } }
        public string Email { get { return this._Email; } set { this._Email = value.Trim(); } }
        public string Fax { get { return this._Fax; } set { this._Fax = value.Trim(); } }
        public string Website { get { return this._Website; } set { this._Website = value.Trim(); } }
        public string Notes { get { return this._Notes; } set { this._Notes = value.Trim(); } }
        public string department { get { return this._department; } set { this._department = value.Trim(); } }
        public string assetDesc { get { return this._assetDesc; } set { this._assetDesc = value.Trim(); } }
        public string assetBarcode { get { return this._assetBarcode; } set { this._assetBarcode = value.Trim(); } }
        public string serialNo { get { return this._serialNo; } set { this._serialNo = value.Trim(); } }
        public string ItemWaranty { get { return this._ItemWaranty; } set { this._ItemWaranty = value.Trim(); } }
        public string AssetCondition { get { return this._AssetCondition; } set { this._AssetCondition = value.Trim(); } }
        public string manuCompany { get { return this._manuCompany; } set { this._manuCompany = value.Trim(); } }
        public string price { get { return this._price; } set { this._price = value.Trim(); } }
        public string invoice { get { return this._invoice; } set { this._invoice = value.Trim(); } }
        public string creationDate { get { return this._creationDate; } set { this._creationDate = value.Trim(); } }
        public string modificationdate { get { return this._modificationdate; } set { this._modificationdate = value.Trim(); } }
        public string currentLocation { get { return this._currentLocation; } set { this._currentLocation = value.Trim(); } }
        public string locationId { get { return this._locationId; } set { this._locationId = value.Trim(); } }
        public string cLocation { get { return this._cLocation; } set { this._cLocation = value.Trim(); } }
        public string cLocationId { get { return this._cLocationId; } set { this._cLocationId = value.Trim(); } }
        public string transferTo { get { return this._transferTo; } set { this._transferTo = value.Trim(); } }
        public string transferToID { get { return this._transferToID; } set { this._transferToID = value.Trim(); } }
        public string transferBy { get { return this._transferBy; } set { this._transferBy = value.Trim(); } }
        public string transferDate { get { return this._transferDate; } set { this._transferDate = value.Trim(); } }
        public string bstatus { get { return this._bstatus; } set { this._bstatus = value.Trim(); } }
        public string CreatedBy { get { return this._CreatedBy; } set { this._CreatedBy = value.Trim(); } }
        public string vendorId { get { return this._vendorId; } set { this._vendorId = value.Trim(); } }
        public string dueDate { get { return this._dueDate; } set { this._dueDate = value.Trim(); } }
        public string AssetId { get { return this._AssetId; } set { this._AssetId = value.Trim(); } }
        public string recType { get { return this._recType; } set { this._recType = value.Trim(); } }
        public string PurchaseDate { get { return this._PurchaseDate; } set { this._PurchaseDate = value.Trim(); } }
        public string imgURL { get { return this._imgURL; } set { this._imgURL = value.Trim(); } }
        public string from { get { return this._from; } set { this._from = value.Trim(); } }
        public string to { get { return this._to; } set { this._to = value.Trim(); } }
        public string status { get { return this._status; } set { this._status = value.Trim(); } }

        #endregion

        #region "Methods"
        public DataSet ManageAsset()
        {
            dbcommand = db.GetStoredProcCommand("sp_AssetMaster", action, nid, Code, CategoryID, name, assetDesc, department, assetBarcode, serialNo, ItemWaranty, _AssetCondition, vendorId, manuCompany, price, invoice, currentLocation, locationId, companyId,Notes,recType,transferBy,transferDate,PurchaseDate,imgURL);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet vendor()
        {
            dbcommand = db.GetStoredProcCommand("sp_AssetVendor", action, nid, Code, VendorName, ContactPerson, Designation,
                Street, Country, State, City, Zip, Phone, Cell, Email, Fax, Website, Notes, HttpContext.Current.Session["companyId"].ToString());
            return db.ExecuteDataSet(dbcommand);
        }

        //public DataSet trasferAssets()
        //{
        //    dbcommand = db.GetStoredProcCommand("sp_transferAsset", action, nid, AssetId, cLocation, cLocationId, transferTo,
        //       transferToID, transferBy, transferDate, creationDate, modificationdate, Notes, bstatus, dueDate);
        //    return db.ExecuteDataSet(dbcommand);
        //}

        //public DataSet trasferAssets()
        //{
        //    dbcommand = db.GetStoredProcCommand("sp_transferAsset", action, nid, AssetId, cLocationId, transferTo,
        //       transferToID, transferBy, transferDate, creationDate, modificationdate, Notes, dueDate, companyId, CategoryID, department, Code, name, recType);
        //    return db.ExecuteDataSet(dbcommand);
        //}

        public DataSet trasferAssets()
        {
            dbcommand = db.GetStoredProcCommand("sp_transferAsset", action, nid, AssetId, cLocationId, transferTo,
               transferToID, transferBy, transferDate, creationDate, modificationdate, Notes, dueDate, companyId, CategoryID, department, Code, name, recType, status, from, to);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet AssetCategory()
        {
            dbcommand = db.GetStoredProcCommand("sp_AssetCategory", action, nid, CategoryID, CategoryName, CategoryDesc, ParentId,companyId);
            return db.ExecuteDataSet(dbcommand);

        }
        public DataSet ReportAsset()
        {
            dbcommand = db.GetStoredProcCommand("rpt_AssetReport", action, nid, companyId, department, CategoryID,locationId);
            return db.ExecuteDataSet(dbcommand);
        }

        
        #endregion
    }
}