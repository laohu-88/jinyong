const ASSETS_CACHE = 'jyf-assets-0.6.30';

self.addEventListener('install', function (event) {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(clients.claim());
});

self.addEventListener('fetch', (event) => {
  let url = event.request.url;
  if (
    url.startsWith('https://jyf-1308455875.file.myqcloud.com/0.6.30/assets/')
  ) {
    let corsRequest = new Request(url, { mode: 'cors' });
    event.respondWith(
      caches.match(corsRequest).then((cachedResponse) => {
        if (cachedResponse) {
          return cachedResponse;
        }
        return caches.open(ASSETS_CACHE).then((cache) => {
          return fetch(corsRequest).then((response) => {
            if (response.status != 200) {
              return response;
            }
            return cache.put(corsRequest, response.clone()).then(() => {
              return response;
            });
          });
        });
      })
    );
  }
});
