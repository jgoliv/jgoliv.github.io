sets <-
  list(

    # cl-first chain: A -> cl -> co·cl -> cl·co·cl -> ...
    list(
      label = "A",
      notation = "(0,1) \u222a (1,2) \u222a {3} \u222a ([4,5] \u2229 \u211a)",
      components = list(
        list(type = "interval", lo = 0, hi = 1, lo_closed = FALSE, hi_closed = FALSE),
        list(type = "interval", lo = 1, hi = 2, lo_closed = FALSE, hi_closed = FALSE),
        list(type = "point", value = 3),
        list(type = "rational_interval", lo = 4, hi = 5, lo_closed = TRUE, hi_closed = TRUE)
      )
    ),

    list(
      label = "cl(A)",
      notation = "[0,2] \u222a {3} \u222a [4,5]",
      components = list(
        list(type = "interval", lo = 0, hi = 2, lo_closed = TRUE, hi_closed = TRUE),
        list(type = "point", value = 3),
        list(type = "interval", lo = 4, hi = 5, lo_closed = TRUE, hi_closed = TRUE)
      )
    ),

    list(
      label = "co\u00b7cl(A)",
      notation = "(-\u221e,0) \u222a (2,3) \u222a (3,4) \u222a (5,+\u221e)",
      components = list(
        list(type = "interval", lo = -Inf, hi = 0, lo_closed = FALSE, hi_closed = FALSE),
        list(type = "interval", lo = 2, hi = 3, lo_closed = FALSE, hi_closed = FALSE),
        list(type = "interval", lo = 3, hi = 4, lo_closed = FALSE, hi_closed = FALSE),
        list(type = "interval", lo = 5, hi = Inf, lo_closed = FALSE, hi_closed = FALSE)
      )
    ),

    list(
      label = "cl\u00b7co\u00b7cl(A)",
      notation = "(-\u221e,0] \u222a [2,4] \u222a [5,+\u221e)",
      components = list(
        list(type = "interval", lo = -Inf, hi = 0, lo_closed = FALSE, hi_closed = TRUE),
        list(type = "interval", lo = 2, hi = 4, lo_closed = TRUE, hi_closed = TRUE),
        list(type = "interval", lo = 5, hi = Inf, lo_closed = TRUE, hi_closed = FALSE)
      )
    ),

    list(
      label = "co\u00b7cl\u00b7co\u00b7cl(A)",
      notation = "(0,2) \u222a (4,5)",
      components = list(
        list(type = "interval", lo = 0, hi = 2, lo_closed = FALSE, hi_closed = FALSE),
        list(type = "interval", lo = 4, hi = 5, lo_closed = FALSE, hi_closed = FALSE)
      )
    ),

    list(
      label = "cl\u00b7co\u00b7cl\u00b7co\u00b7cl(A)",
      notation = "[0,2] \u222a [4,5]",
      components = list(
        list(type = "interval", lo = 0, hi = 2, lo_closed = TRUE, hi_closed = TRUE),
        list(type = "interval", lo = 4, hi = 5, lo_closed = TRUE, hi_closed = TRUE)
      )
    ),

    list(
      label = "co\u00b7cl\u00b7co\u00b7cl\u00b7co\u00b7cl(A)",
      notation = "(-\u221e,0) \u222a (2,4) \u222a (5,+\u221e)",
      components = list(
        list(type = "interval", lo = -Inf, hi = 0, lo_closed = FALSE, hi_closed = FALSE),
        list(type = "interval", lo = 2, hi = 4, lo_closed = FALSE, hi_closed = FALSE),
        list(type = "interval", lo = 5, hi = Inf, lo_closed = FALSE, hi_closed = FALSE)
      )
    ),

    # co-first chain: co·cl·co·cl·co·cl·co(A) -> ... -> cl·co -> co
    list(
      label = "co\u00b7cl\u00b7co\u00b7cl\u00b7co\u00b7cl\u00b7co(A)",
      notation = "(0,2)",
      components = list(
        list(type = "interval", lo = 0, hi = 2, lo_closed = FALSE, hi_closed = FALSE)
      )
    ),

    list(
      label = "cl\u00b7co\u00b7cl\u00b7co\u00b7cl\u00b7co(A)",
      notation = "(-\u221e,0] \u222a [2,+\u221e)",
      components = list(
        list(type = "interval", lo = -Inf, hi = 0, lo_closed = FALSE, hi_closed = TRUE),
        list(type = "interval", lo = 2, hi = Inf, lo_closed = TRUE, hi_closed = FALSE)
      )
    ),

    list(
      label = "co\u00b7cl\u00b7co\u00b7cl\u00b7co(A)",
      notation = "(-\u221e,0) \u222a (2,+\u221e)",
      components = list(
        list(type = "interval", lo = -Inf, hi = 0, lo_closed = FALSE, hi_closed = FALSE),
        list(type = "interval", lo = 2, hi = Inf, lo_closed = FALSE, hi_closed = FALSE)
      )
    ),

    list(
      label = "cl\u00b7co\u00b7cl\u00b7co(A)",
      notation = "[0,2]",
      components = list(
        list(type = "interval", lo = 0, hi = 2, lo_closed = TRUE, hi_closed = TRUE)
      )
    ),

    list(
      label = "co\u00b7cl\u00b7co(A)",
      notation = "(0,1) \u222a (1,2)",
      components = list(
        list(type = "interval", lo = 0, hi = 1, lo_closed = FALSE, hi_closed = FALSE),
        list(type = "interval", lo = 1, hi = 2, lo_closed = FALSE, hi_closed = FALSE)
      )
    ),

    list(
      label = "cl\u00b7co(A)",
      notation = "(-\u221e,0] \u222a {1} \u222a [2,+\u221e)",
      components = list(
        list(type = "interval", lo = -Inf, hi = 0, lo_closed = FALSE, hi_closed = TRUE),
        list(type = "point", value = 1),
        list(type = "interval", lo = 2, hi = Inf, lo_closed = TRUE, hi_closed = FALSE)
      )
    ),

    list(
      label = "co(A)",
      notation = "(-\u221e,0] \u222a {1} \u222a [2,3) \u222a (3,4) \u222a ([4,5] \u2229 \u211d\\\u211a) \u222a (5,+\u221e)",
      components = list(
        list(type = "interval", lo = -Inf, hi = 0, lo_closed = FALSE, hi_closed = TRUE),
        list(type = "point", value = 1),
        list(type = "interval", lo = 2, hi = 3, lo_closed = TRUE, hi_closed = FALSE),
        list(type = "interval", lo = 3, hi = 4, lo_closed = FALSE, hi_closed = FALSE),
        list(type = "irrational_interval", lo = 4, hi = 5, lo_closed = TRUE, hi_closed = TRUE),
        list(type = "interval", lo = 5, hi = Inf, lo_closed = FALSE, hi_closed = FALSE)
      )
    )

  )
