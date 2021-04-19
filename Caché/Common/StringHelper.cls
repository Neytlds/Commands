/// 字符串帮助类
Class Custom.Common.StringHelper Extends %Persistent
{

/// <summary>
/// 判断 Value 是否存于 CheckStr 中
/// </summary>
/// <param name="CheckStr">目标串</param>
/// <param name="ValueStr">需交验串</param>
/// <param name="Delim">分割符</param>
/// <param name="Sigle">单一校验标识，默认：Y</param>
/// <returns>0：不存在；1：存在</returns>
/// <debugger>w ##class(Custom.Common.StringHelper).CheckExitFlag("1*2*3","3*2","*","Y")</debugger>
ClassMethod CheckExitFlag(CheckStr, ValueStr, Delim = "^", Sigle = "") As %String
{
  Set ExitFlag = 0
  Quit:(CheckStr = "")||(ValueStr = "") ExitFlag
  If Sigle = "Y" {
    For len = 1 : 1 : $LENGTH(ValueStr, Delim) Do
    .Set Value = $PIECE(ValueStr, Delim, len)
    .Quit:(Value = "")||(ExitFlag = 1)
    .Do CheckExit
  } Else {
    Set Value = ValueStr
    Do CheckExit
  }
  
  Quit ExitFlag

CheckExit 
  Set Value = Delim_Value_Delim
  Set CheckStr = Delim_CheckStr_Delim
  Set:CheckStr[Value ExitFlag = 1
  Quit ""
}

}