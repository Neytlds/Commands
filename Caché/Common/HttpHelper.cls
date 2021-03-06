/// 发起 http 请求
Class Custom.Common.HttpHelper Extends %Persistent
{

ClassMethod SendGet()
{
    Set httprequest=##class(%Net.HttpRequest).%New()
    Set httprequest.Server="https://v0.yiketianqi.com/"
    Do httprequest.Get("/api")
    Do httprequest.HttpResponse.OutputToDevice()
}

ClassMethod SendPost()
{
	Set reqParams = { "sign": "2C", "timeStamp": 1585537842193, "mrn": "23498763" }.%ToJSON()
	Set httprequest = ##class(%Net.HttpRequest).%New()
	Set httprequest.ContentType = "application/json"
	Set httprequest.ContentCharset = "UTF-8"

    // 但出现“错误 #6159: 尽管已经打开HTTPS，但由于没有指定SSLConfiguration，依然无法建立HTTPS连接。”时，需要设置 SSL/TLS 和下面的三句话
	Set httprequest.Https = 1
	Set httprequest.SSLConfiguration = "配置名称"
	Set httprequest.SSLCheckServerIdentity = 0

	Do httprequest.EntityBody.Write(reqParams)
	Set sc = httprequest.Post("https://test-my.ufh.com.cn/api/ehis/openapi/prescription/getPrescriptionList", 0)

    // 如果上面的 Post 方法发送失败，打印错误消息
    If $$$ISERR(sc) {
        Write $SYSTEM.Status.GetErrorText(sc)
    }
	
	Set response = httprequest.HttpResponse
	
	Set json = ""
	If $ISOBJECT(response.Data) {
		Set objStream = response.Data
		
		Set json = ""
		While ('objStream.AtEnd) {
		   	Set json = json _ objStream.ReadLine()
		}
	} Else {
		Set json = response.Data
	}
		
	ZWrite json
}
}