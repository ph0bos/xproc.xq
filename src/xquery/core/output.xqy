xquery version "1.0-ml"  encoding "UTF-8";

module namespace output = "http://xproc.net/xproc/output";

import module namespace const  = "http://xproc.net/xproc/const"  at "/xquery/core/const.xqy";
import module namespace     u  = "http://xproc.net/xproc/util"   at "/xquery/core/util.xqy";

(:~ declare namespaces :)
declare namespace xproc = "http://xproc.net/xproc";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

(:~ output:seriaize - serializes output 
 :
 : @param $result - all outputs from the result of processing pipeline
 :                  $result[1] - abstract tree
 :                  $result[2...n] - result
 :
 : @param $dflag - if true will output full processing trace
 :
 : @returns item()* 
 :)
(: -------------------------------------------------------------------------- :)
declare function output:serialize(
    $result as item()*,
    $dflag as xs:integer
    ) as item()*
{

 let $ast :=subsequence($result,1,1)
 return
    if($dflag eq 1) then
        element xproc:debug{
          element xproc:pipeline {$ast},
          element xproc:outputs {$u:inputMap}
        }
    else u:getInputMap('!1!')
 };

(:~ output:seriaize - serializes output 
 :
 : @param $result - all outputs from the result of processing pipeline
 :                  $result[1] - abstract tree
 :                  $result[2...n] - result
 :
 : @param $dflag - if true will output full processing trace
 :
 : @returns item()* 
 :)
(: -------------------------------------------------------------------------- :)
declare function output:serialize(
    $result as item()*,
    $dflag as xs:integer,
    $level as xs:integer
    ) as item()*
{

 let $ast :=subsequence($result,1,1)
 return
    if($dflag eq 1) then
        element xproc:debug{
          element xproc:pipeline {$ast},
          element xproc:outputs {$u:inputMap}
        }
    else
        let $map  := xdmp:get-server-field("xproc:input-map")
        let $keys :=  for $key in map:keys($map)
        return
          if (ends-with(string($key),'!') ) then string($key)
          else () 
    return u:getInputMap($keys[last()])
 };