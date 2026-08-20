import{r as o,F as p,H as N,c as w}from"./index-BCeXwtIm.js";function m(a,{container:e,accept:r,walk:t}){let c=o.useRef(r),n=o.useRef(t);o.useEffect(()=>{c.current=r,n.current=t},[r,t]),p(()=>{if(!e||!a)return;let s=N(e);if(!s)return;let u=c.current,i=n.current,d=Object.assign(l=>u(l),{acceptNode:u}),f=s.createTreeWalker(e,NodeFilter.SHOW_ELEMENT,d,!1);for(;f.nextNode();)i(f.currentNode)},[e,a,c,n])}/**
 * @license lucide-react v0.559.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const E=[["path",{d:"M12 5v14",key:"s699le"}],["path",{d:"m19 12-7 7-7-7",key:"1idqje"}]],x=w("arrow-down",E);export{x as A,m as F};
