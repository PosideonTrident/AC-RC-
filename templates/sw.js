// Service Worker for Hisense AC Control PWA

const CACHE_NAME = 'hisense-ac-v1';
const urlsToCache = [
    '/',
    '/manifest.json',
    '/sw.js'
];

// Install event
self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            return cache.addAll(urlsToCache);
        })
    );
    self.skipWaiting();
});

// Activate event
self.addEventListener('activate', (event) => {
    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames.map((cacheName) => {
                    if (cacheName !== CACHE_NAME) {
                        return caches.delete(cacheName);
                    }
                })
            );
        })
    );
    self.clients.claim();
});

// Fetch event - Network first, fall back to cache
self.addEventListener('fetch', (event) => {
    // Skip API calls, let them hit network
    if (event.request.url.includes('/api/')) {
        return;
    }

    event.respondWith(
        fetch(event.request)
            .then((response) => {
                // Cache successful responses
                if (response.status === 200) {
                    const responseToCache = response.clone();
                    caches.open(CACHE_NAME).then((cache) => {
                        cache.put(event.request, responseToCache);
                    });
                }
                return response;
            })
            .catch(() => {
                // Fall back to cache on network error
                return caches.match(event.request).then((response) => {
                    return response || new Response('Network error', { status: 503 });
                });
            })
    );
});

// Handle background sync (future feature)
self.addEventListener('sync', (event) => {
    if (event.tag === 'sync-ac') {
        event.waitUntil(
            fetch('/api/status')
                .then(() => console.log('Background sync complete'))
                .catch(() => console.log('Background sync failed'))
        );
    }
});
