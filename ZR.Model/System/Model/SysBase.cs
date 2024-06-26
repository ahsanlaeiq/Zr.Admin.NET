namespace ZR.Model.System
{
    //[EpplusTable(PrintHeaders = true, AutofitColumns = true, AutoCalculate = true, ShowTotal = true)]
    public class SysBase
    {
        /// <summary>
        /// Creator
        /// </summary>
        [SugarColumn(IsOnlyIgnoreUpdate = true, Length = 64, IsNullable = true)]
        [JsonProperty(propertyName: "createBy")]
        [ExcelIgnore]
        public string Create_by { get; set; }

        /// <summary>
        /// Creation time
        /// </summary>
        [SugarColumn(IsOnlyIgnoreUpdate = true, IsNullable = true)]
        [JsonProperty(propertyName: "createTime")]
        [ExcelColumn(Format = "yyyy-MM-dd HH:mm:ss")]
        public DateTime Create_time { get; set; } = DateTime.Now;

        /// <summary>
        /// Updater
        /// </summary>
        [JsonIgnore]
        [JsonProperty(propertyName: "updateBy")]
        [SugarColumn(IsOnlyIgnoreInsert = true, Length = 64, IsNullable = true)]
        [ExcelIgnore]
        public string Update_by { get; set; }

        /// <summary>
        /// Update time
        /// </summary>
        //[JsonIgnore]
        [SugarColumn(IsOnlyIgnoreInsert = true, IsNullable = true)]
        [JsonProperty(propertyName: "updateTime")]
        [ExcelIgnore]
        public DateTime? Update_time { get; set; }
        [SugarColumn(Length = 500)]
        public string Remark { get; set; }
    }
}
