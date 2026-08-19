import{r as o,E as p,F as E,c as N}from"./index-QnSR9iAx.js";function m(a,{container:e,accept:r,walk:t}){let c=o.useRef(r),n=o.useRef(t);o.useEffect(()=>{c.current=r,n.current=t},[r,t]),p(()=>{if(!e||!a)return;let s=E(e);if(!s)return;let u=c.current,i=n.current,d=Object.assign(l=>u(l),{acceptNode:u}),f=s.createTreeWalker(e,NodeFilter.SHOW_ELEMENT,d,!1);for(;f.nextNode();)i(f.currentNode)},[e,a,c,n])}/**
 * @license lucide-react v0.559.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const w=[["path",{d:"M12 5v14",key:"s699le"}],["path",{d:"m19 12-7 7-7-7",key:"1idqje"}]],x=N("arrow-down",w);export{x as A,m as F};
