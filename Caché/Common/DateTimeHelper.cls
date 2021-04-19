/// 时间日期帮助类
Class Custom.Common.DateTimeHelper Extends %Persistent
{

/// <summary>
/// 获取时间戳（TimeStamp）
/// 在线转换工具：https://tool.lu/timestamp
/// </summary>
/// <param name="time">要获取时间戳的时间，默认为系统当前时间</param>
/// <param name="interval">间隔</param>
/// <returns>时间戳（TimeStamp）</returns>
/// <debugger>w ##class(Custom.Common.DateTimeHelper).TimeInSeconds()</debugger>
ClassMethod TimeInSeconds(time As %String = "", interval As %Integer = 0) As %Integer
{
  If time = "" {
    Set time = $ZTIMESTAMP // 默认采用 UTC 时间
  }
  Quit ((($PIECE(time, ",") - 47117) * 86400 + $PIECE(time, ",", 2) + interval) * 1000) \ 1
}

}