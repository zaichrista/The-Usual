/* The Usual: offline shell. Bump VERSION to force clients to refetch. */
const VERSION='v1';
const CACHE='the-usual-'+VERSION;
const SHELL=['./','index.html','manifest.webmanifest','icon-192.png','icon-512.png','apple-touch-icon.png'];
const EXTRA=['https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.119.0/dist/umd/supabase.js','https://use.typekit.net/rij0fmg.css'];
self.addEventListener('install',e=>{
  e.waitUntil((async()=>{
    const c=await caches.open(CACHE);
    await c.addAll(SHELL);
    await Promise.all(EXTRA.map(u=>c.add(new Request(u,{mode:u.includes('jsdelivr')?'cors':'no-cors'})).catch(()=>{})));
    self.skipWaiting();
  })());
});
self.addEventListener('activate',e=>{
  e.waitUntil((async()=>{
    for(const k of await caches.keys())if(k.startsWith('the-usual-')&&k!==CACHE)await caches.delete(k);
    await self.clients.claim();
  })());
});
self.addEventListener('fetch',e=>{
  const r=e.request,u=new URL(r.url);
  if(r.method!=='GET')return;
  if(u.hostname.endsWith('supabase.co')||u.hostname==='api.themoviedb.org')return; /* live data: never cached here */
  const poster=u.hostname==='image.tmdb.org';
  const known=u.origin===location.origin||poster||u.hostname==='cdn.jsdelivr.net'||u.hostname.endsWith('typekit.net');
  if(!known)return;
  e.respondWith((async()=>{
    const c=await caches.open(CACHE);
    const hit=await c.match(r,{ignoreSearch:r.mode==='navigate'});
    const net=fetch(r).then(res=>{if(res&&(res.ok||res.type==='opaque'))c.put(r,res.clone());return res}).catch(()=>null);
    if(hit){e.waitUntil(net);return hit}            /* cache first, refresh in background */
    const res=await net;
    return res||(r.mode==='navigate'?await c.match('index.html'):Response.error());
  })());
});
