import{c as r,K as s}from"./index-BPFZCng8.js";/**
 * @license lucide-react v0.559.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const n=[["path",{d:"m21 21-4.34-4.34",key:"14j7rj"}],["circle",{cx:"11",cy:"11",r:"8",key:"4ej97u"}]],i=r("search",n);async function p(){return s("/api/transport_keys")}async function d(o){return s("/api/transport_keys",{method:"POST",body:JSON.stringify(o)})}async function l(o,e){return s(`/api/transport_key/${o}`,{method:"PUT",body:JSON.stringify(e)})}async function y(o){return s(`/api/transport_key/${o}`,{method:"DELETE"})}async function u(){var o,e;try{const a=(e=(o=(await s("/api/stats")).config)==null?void 0:o.mesh)==null?void 0:e.unscoped_flood_allow;return typeof a!="boolean"?{success:!1,error:"Unscoped flood policy is unavailable"}:{success:!0,data:{unscoped_flood_allow:a}}}catch(t){return{success:!1,error:t instanceof Error?t.message:"Unscoped flood policy is unavailable"}}}async function f(o){return s("/api/unscoped_flood_policy",{method:"POST",body:JSON.stringify({unscoped_flood_allow:o})})}export{i as S,u as a,d as c,y as d,p as g,f as s,l as u};
