/*
    -Created by: Wesley Blackwell
    -Date last updated: 5/1/2022
    -Overview:
        This script connects Power BI to the MSFT Security Advanced Hunting API. 
    -Overview doc, Create custom reports using Power BI (iunstructions on setting up report): https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/api-power-bi?view=o365-worldwide
    -Overview doc, API info for Government (GCC): https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/gov?view=o365-worldwide#api
    -Permissions Needed:
        -Security Admin: Connect to API and pull down data in Power BI
    -Notes:
        -
*/
let
        //UPDATE: Insert MDE Advanced Hunting Query below. User Double quotes (""string"") to eapce any quotes used.
        AdvancedHuntingQuery = "DeviceEvents | where ActionType contains 'Anti' | limit 20",

        HuntingUrl = "https://api.security.microsoft.us/api/advancedhunting",
        //For GCC use below
        //HuntingUrl = "https://api-gcc.security.microsoft.us/api/advancedhunting",

        Response = Json.Document(Web.Contents(HuntingUrl, [Query=[key=AdvancedHuntingQuery]])),

        TypeMap = #table(
            { "Type", "PowerBiType" },
            {
                { "Double",   Double.Type },
                { "Int64",    Int64.Type },
                { "Int32",    Int32.Type },
                { "Int16",    Int16.Type },
                { "UInt64",   Number.Type },
                { "UInt32",   Number.Type },
                { "UInt16",   Number.Type },
                { "Byte",     Byte.Type },
                { "Single",   Single.Type },
                { "Decimal",  Decimal.Type },
                { "TimeSpan", Duration.Type },
                { "DateTime", DateTimeZone.Type },
                { "String",   Text.Type },
                { "Boolean",  Logical.Type },
                { "SByte",    Logical.Type },
                { "Guid",     Text.Type }
            }),

        Schema = Table.FromRecords(Response[Schema]),
        TypedSchema = Table.Join(Table.SelectColumns(Schema, {"Name", "Type"}), {"Type"}, TypeMap , {"Type"}),
        Results = Response[Results],
        Rows = Table.FromRecords(Results, Schema[Name]),
        Table = Table.TransformColumnTypes(Rows, Table.ToList(TypedSchema, (c) => {c{0}, c{2}}))

    in Table