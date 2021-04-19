/// XML、JSON和数组之间的转换 测试类
Class Custom.Common.Demo Extends %Persistent
{

/// 得到测试数组
/// w ##class(DHCDoc.Util.FromXML).TestGet()
ClassMethod TestGet() As %ArrayOfDataTypes
{
  s ArrayObj=##class(%ArrayOfDataTypes).%New()
  d ArrayObj.SetAt(1,"a")
  s ArrayObj1=##class(%ArrayOfDataTypes).%New()
  d ArrayObj1.SetAt(2,"c")
  d ArrayObj.SetAt(ArrayObj1,"b")
  s JsonStr=..Arr2Json(ArrayObj)
  w "数组转json："_JsonStr.Read(),!
  s Arr=..Json2Arr(JsonStr)
  
  s Code="First",Desc="第一层"
  s ArrayObj=##class(%ArrayOfDataTypes).%New()
  d ArrayObj.SetAt(Code,"Code")
  d ArrayObj.SetAt(Desc,"Desc_Text")
  ;s PhotoStream=##class(ext.util.String).Img2Base64("C:\Users\LX\Pictures\2.jpg") 
  s PhotoStream=##class(%Stream.GlobalCharacter).%New()
  d PhotoStream.Write("策划师")
  d ArrayObj.SetAt(PhotoStream,"Photo")
  s DataObj=##class(%ListOfDataTypes).%New()
  f List=1:1:2 {
    s CodeList="Second:"_List,DescList="第二层:"_List
    s ArraySubObj=##class(%ArrayOfDataTypes).%New()
    d ArraySubObj.SetAt(CodeList,"CodeS")
    d ArraySubObj.SetAt(DescList,"DescS")
    ;三层节点
    s SubObj=##class(%ListOfDataTypes).%New()
    f Sub=1:1:5 {
      s CodeSub="Third:"_Sub,DescSub="第三层:"_Sub
      s SubArr=##class(%ArrayOfDataTypes).%New()
      d SubArr.SetAt(CodeSub,"CodeT")
      d SubArr.SetAt(DescSub,"DescT")
      d SubObj.Insert(SubArr)
    }
    d ArraySubObj.SetAt(SubObj,"DataT")
    d DataObj.Insert(ArraySubObj)
  }
  d ArrayObj.SetAt(DataObj,"DataS")
  s XMLArr=##class(%ArrayOfDataTypes).%New()
  d XMLArr.SetAt(ArrayObj,"Request")
  q XMLArr
}

/// 测试数组、XML、Json互转
/// w ##class(DHCDoc.Util.FromXML).TestJsonXML()
ClassMethod TestJsonXML() As %String
{
  s ArrObj=..TestGet()
  
  s XMLStr=..Arr2XML(ArrObj)  
  w "数组转XML：  "_XMLStr.Read() ,!
  
  s XMLStr=..XMLRoot(ArrObj)
  w "添加根节点和xml头：  "_XMLStr.Read() ,!
  
  w "XML转数组：" ,!
  s Arr=..XML2Arr(XMLStr,"Request") 
  i $IsObject(Arr) { 
    w "   Code："_Arr.Data("Code") ,!
    w "   Desc_Text："_Arr.Data("Desc_Text") ,!
    i Arr.IsDefined("Photo") d
    .w "      Photo："_Arr.Data("Photo") ,!
    w "   DataSSum："_Arr.Data("DataS").Count() ,!
    w "   DataS.Code："_Arr.Data("DataS").GetAt(1).Data("CodeS") ,!
  }else{
    w "解析失败："_Arr
    q ""
  }

  s JsonStr=..Arr2Json(ArrObj)
  w "数组转Json： "_JsonStr.Read() ,!

  w "Json转数组：" ,!
  s Arr=..Json2Arr(JsonStr)
  s Arr=##class(DHCDoc.Util.FromXML).Json2Arr(JsonStr)
  w " Code："_Arr.Data("Request").Data("Code") ,!
  w " DataSSum："_Arr.Data("Request").Data("DataS").Count() ,!
  w " DataS.Code："_Arr.Data("Request").Data("DataS").GetAt(1).Data("CodeS") ,!  
  
  w "XML转Json1：",!
  s JsonStr=..Xml2Json(XMLStr)
  w "   "_JsonStr.Read() ,!
  
  ;Xml2JsonOld可能不符合要求，需要重新再构建生成json
  s XML="<Request><list><deptInfos><deptCode></deptCode><deptDesc></deptDesc><deptName></deptName><hosOrgCode></hosOrgCode><indexNo></indexNo><isDelete></isDelete><isRegister></isRegister><normdeptCode></normdeptCode><normdeptName></normdeptName></deptInfos><deptInfos><deptCode></deptCode><deptDesc></deptDesc><deptName></deptName><hosOrgCode></hosOrgCode><indexNo></indexNo><isDelete></isDelete><isRegister></isRegister><normdeptCode></normdeptCode><normdeptName></normdeptName></deptInfos><deptInfos><deptCode>12345</deptCode><deptDesc></deptDesc><deptName></deptName><hosOrgCode></hosOrgCode><indexNo></indexNo><isDelete></isDelete><isRegister></isRegister><normdeptCode></normdeptCode><normdeptName></normdeptName></deptInfos><deptInfos><deptCode></deptCode><deptDesc></deptDesc><deptName></deptName><hosOrgCode></hosOrgCode><indexNo></indexNo><isDelete></isDelete><isRegister></isRegister><normdeptCode></normdeptCode><normdeptName></normdeptName></deptInfos></list><messageHeader><accessAccount></accessAccount><sign></sign></messageHeader></Request>"
  w "XML转Json转换前：",!
  s JsonStr=..Xml2JsonOld(XML,"Request")
  w "   "_JsonStr.Read() ,!
  
  s Arr=..Json2Arr(JsonStr)
  s Arr1=##class(%ArrayOfDataTypes).%New()
  d Arr1.SetAt(Arr.Data("list").Data("1").Data("deptInfos"),"list")
  d Arr1.SetAt(Arr.Data("list").Data("1").Data("messageHeader").Data(1),"messageHeader")
  s JsonNew=..Arr2Json(Arr1)
  w "XML转Json转换后：",!
  w "   "_JsonNew.Read() ,!

  q ""
}

// 运行调试方法： w ##class(DHCDoc.Util.FromXML).TestJsonXML()，输入如下：
// 数组转json：{"a":"1","b":{"c":"2"}}
// 数组转XML：
//     <Request><Code>First</Code><DataS><CodeS>Second:1</CodeS><DataT><CodeT>Third:1</CodeT><DescT>第三层:1</DescT></DataT><DataT><CodeT>Third:2</CodeT><DescT>第三层:2</DescT></DataT><DataT><CodeT>Third:3</CodeT><DescT>第三层:3</DescT></DataT><DataT><CodeT>Third:4</CodeT><DescT>第三层:4</DescT></DataT><DataT><CodeT>Third:5</CodeT><DescT>第三层:5</DescT></DataT><DescS>第二层:1</DescS></DataS><DataS><CodeS>Second:2</CodeS><DataT><CodeT>Third:1</CodeT><DescT>第三层:1</DescT></DataT><DataT><CodeT>Third:2</CodeT><DescT>第三层:2</DescT></DataT><DataT><CodeT>Third:3</CodeT><DescT>第三层:3</DescT></DataT><DataT><CodeT>Third:4</CodeT><DescT>第三层:4</DescT></DataT><DataT><CodeT>Third:5</CodeT><DescT>第三层:5</DescT></DataT><DescS>第二层:2</DescS></DataS><Desc_Text>第一层</Desc_Text><Photo>策划师</Photo></Request>
// 添加根节点和xml头：
//   <?xml version="1.0" encoding="UTF-8"?><Request><Code>First</Code><DataS><CodeS>Second:1</CodeS><DataT><CodeT>Third:1</CodeT><DescT>第三层:1</DescT></DataT><DataT><CodeT>Third:2</CodeT><DescT>第三层:2</DescT></DataT><DataT><CodeT>Third:3</CodeT><DescT>第三层:3</DescT></DataT><DataT><CodeT>Third:4</CodeT><DescT>第三层:4</DescT></DataT><DataT><CodeT>Third:5</CodeT><DescT>第三层:5</DescT></DataT><DescS>第二层:1</DescS></DataS><DataS><CodeS>Second:2</CodeS><DataT><CodeT>Third:1</CodeT><DescT>第三层:1</DescT></DataT><DataT><CodeT>Third:2</CodeT><DescT>第三层:2</DescT></DataT><DataT><CodeT>Third:3</CodeT><DescT>第三层:3</DescT></DataT><DataT><CodeT>Third:4</CodeT><DescT>第三层:4</DescT></DataT><DataT><CodeT>Third:5</CodeT><DescT>第三层:5</DescT></DataT><DescS>第二层:2</DescS></DataS><Desc_Text>第一层</Desc_Text><Photo>策划师</Photo></Request>
// XML转数组：
//     Code：First
//     Desc_Text：第一层
//       Photo：策划师
//     DataSSum：2
//     DataS.Code：Second:1
// 数组转Json：
//     {"Request":{"Code":"First","DataS":[{"CodeS":"Second:1","DataT":[{"CodeT":"Third:1","DescT":"第三层:1"},{"CodeT":"Third:2","DescT":"第三层:2"},{"CodeT":"Third:3","DescT":"第三层:3"},{"CodeT":"Third:4","DescT":"第三层:4"},{"CodeT":"Third:5","DescT":"第三层:5"}],"DescS":"第二层:1"},{"CodeS":"Second:2","DataT":[{"CodeT":"Third:1","DescT":"第三层:1"},{"CodeT":"Third:2","DescT":"第三层:2"},{"CodeT":"Third:3","DescT":"第三层:3"},{"CodeT":"Third:4","DescT":"第三层:4"},{"CodeT":"Third:5","DescT":"第三层:5"}],"DescS":"第二层:2"}],"Desc_Text":"第一层","Photo":"策划师"}}
// Json转数组：
//   Code：First
//   DataSSum：2
//   DataS.Code：Second:1
// XML转Json1：
//     {"Code":"First","DataS":[{"CodeS":"Second:1","DataT":[{"CodeT":"Third:1","DescT":"第三层:1"},{"CodeT":"Third:2","DescT":"第三层:2"},{"CodeT":"Third:3","DescT":"第三层:3"},{"CodeT":"Third:4","DescT":"第三层:4"},{"CodeT":"Third:5","DescT":"第三层:5"}],"DescS":"第二层:1"},{"CodeS":"Second:2","DataT":[{"CodeT":"Third:1","DescT":"第三层:1"},{"CodeT":"Third:2","DescT":"第三层:2"},{"CodeT":"Third:3","DescT":"第三层:3"},{"CodeT":"Third:4","DescT":"第三层:4"},{"CodeT":"Third:5","DescT":"第三层:5"}],"DescS":"第二层:2"}],"Desc_Text":"第一层","Photo":"策划师"}
// XML转Json转换前：
//     {"list":[{"deptInfos":[{"deptCode":"","deptDesc":"","deptName":"","hosOrgCode":"","indexNo":"","isDelete":"","isRegister":"","normdeptCode":"","normdeptName":""},{"deptCode":"","deptDesc":"","deptName":"","hosOrgCode":"","indexNo":"","isDelete":"","isRegister":"","normdeptCode":"","normdeptName":""},{"deptCode":"12345","deptDesc":"","deptName":"","hosOrgCode":"","indexNo":"","isDelete":"","isRegister":"","normdeptCode":"","normdeptName":""},{"deptCode":"","deptDesc":"","deptName":"","hosOrgCode":"","indexNo":"","isDelete":"","isRegister":"","normdeptCode":"","normdeptName":""}],"messageHeader":[{"accessAccount":"","sign":""}]}]}
// XML转Json转换后：
//     {"list":{"1":{"deptCode":"","deptDesc":"","deptName":"","hosOrgCode":"","indexNo":"","isDelete":"","isRegister":"","normdeptCode":"","normdeptName":""},"2":{"deptCode":"","deptDesc":"","deptName":"","hosOrgCode":"","indexNo":"","isDelete":"","isRegister":"","normdeptCode":"","normdeptName":""},"3":{"deptCode":"12345","deptDesc":"","deptName":"","hosOrgCode":"","indexNo":"","isDelete":"","isRegister":"","normdeptCode":"","normdeptName":""},"4":{"deptCode":"","deptDesc":"","deptName":"","hosOrgCode":"","indexNo":"","isDelete":"","isRegister":"","normdeptCode":"","normdeptName":""}},"messageHeader":{"accessAccount":"","sign":""}}

}