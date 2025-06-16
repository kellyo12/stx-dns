;; --------------------------------------------
;; Contract: stx-dns
;; Purpose: Decentralized leasing of human-readable .stx names
;; --------------------------------------------

(define-constant ERR_NAME_TAKEN (err u100))
(define-constant ERR_NOT_OWNER (err u101))
(define-constant ERR_NOT_FOUND (err u102))
(define-constant ERR_EXPIRED (err u103))
(define-constant ERR_INVALID_NAME (err u104))

;; Domain lease period in blocks (e.g. ~30 days = 5250 blocks)
(define-constant default-lease u5250)

;; Data map to store domains
(define-map domains
  (buff 32) ;; name
  {
    owner: principal,
    expires-at: uint,
    target: (optional principal), ;; optional mapping to another address
    metadata: (optional (buff 80)) ;; optional IPNS hash or similar
  }
)

;; === Register ===
(define-public (register (name (buff 32)) (target (optional principal)) (meta (optional (buff 80))))
  (let ((existing (map-get? domains name)))
    (match existing 
           domain (asserts! (>= stacks-block-height (get expires-at domain)) ERR_NAME_TAKEN)
           true)
    (map-set domains name {
      owner: tx-sender,
      expires-at: (+ stacks-block-height default-lease),
      target: target,
      metadata: meta
    })
    (ok true)
  )
)

;; === Renew ===
(define-public (renew (name (buff 32)))
  (let ((domain (map-get? domains name)))
    (match domain
        existing-domain (begin
          (asserts! (is-eq tx-sender (get owner existing-domain)) ERR_NOT_OWNER)
          (map-set domains name (merge existing-domain {
            expires-at: (+ (get expires-at existing-domain) default-lease)
          }))
          (ok true)
        )
        ERR_NOT_FOUND
    )
  )
)

;; === Transfer ===
(define-public (transfer (name (buff 32)) (new-owner principal))
  (let ((domain (map-get? domains name)))
    (match domain
      some-domain (begin
        (asserts! (is-eq tx-sender (get owner some-domain)) ERR_NOT_OWNER)
        (map-set domains name (merge some-domain { owner: new-owner }))
        (ok true)
      )
      ERR_NOT_FOUND)
  )
)

;; === Update Metadata ===
(define-public (update-target (name (buff 32)) (new-target (optional principal)) (meta (optional (buff 80))))
  (let ((domain (map-get? domains name)))
    (match domain
      some-domain
        (begin
          (asserts! (is-eq tx-sender (get owner some-domain)) ERR_NOT_OWNER)
          (map-set domains name (merge some-domain {
            target: new-target,
            metadata: meta
          }))
          (ok true)
        )
      ERR_NOT_FOUND
    )
  )
)

;; === View ===
(define-read-only (resolve (name (buff 32)))
  (let ((domain (map-get? domains name)))
    (match domain
      some-domain
        (if (>= (get expires-at some-domain) stacks-block-height)
          (ok some-domain)
          ERR_EXPIRED
        )
      ERR_NOT_FOUND
    )
  )
)