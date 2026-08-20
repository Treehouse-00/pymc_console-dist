import{r as o,F as k,H as p,c as N}from"./index-ouKnUBRX.js";function E(a,{container:e,accept:c,walk:r}){let t=o.useRef(c),n=o.useRef(r);o.useEffect(()=>{t.current=c,n.current=r},[c,r]),k(()=>{if(!e||!a)return;let l=p(e);if(!l)return;let s=t.current,f=n.current,i=Object.assign(d=>s(d),{acceptNode:s}),u=l.createTreeWalker(e,NodeFilter.SHOW_ELEMENT,i,!1);for(;u.nextNode();)f(u.currentNode)},[e,a,t,n])}/**
 * @license lucide-react v0.559.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const m=[["path",{d:"M12 6v6l4 2",key:"mmk7yg"}],["circle",{cx:"12",cy:"12",r:"10",key:"1mglay"}]],x=N("clock",m);export{x as C,E as F};
