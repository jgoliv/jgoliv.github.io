## -- set up -----------------------------------------------------------------
library(ggplot2)
library(dplyr)
library(purrr)
library(tibble)
library(showtext)
library(ggtext)

source("portfolio/data-viz/math-series/kuratowski-closure-complement/files/data.R")

DISPLAY_MIN <- -3
DISPLAY_MAX <- 6

# -- fonts ---------------------------------------------------------------------
base_font_path <- "www/fonts"

font_add(
  family = "RubikMonoOne",
  regular = file.path(base_font_path, "RubikMonoOne-Regular.ttf")
)

font_add(
  family = "ShareTechMono",
  regular = file.path(base_font_path, "ShareTechMono-Regular.ttf"),
  bold = file.path(base_font_path, "ShareTechMono-Regular.ttf")
)

font_add(
  family = "JuliaMono",
  regular = file.path(base_font_path, "JuliaMono-Regular.ttf"),
  bold = file.path(base_font_path, "JuliaMono-Bold.ttf")
)

showtext_auto()
showtext_opts(dpi = 300)

# -- labels ------------------------------------------------------------------
y_labels <- map_chr(sets, "label")
y_levels <- rev(y_labels)

df_notations <- tibble(
  label = factor(y_labels, levels = y_levels),
  notation = map_chr(sets, "notation")
)

df_grid <- tibble(
  label = factor(y_levels, levels = y_levels)
)

# -- flatten sets into data frames ---------------------------------------------
df_segs <- 
  sets |>
  map(\(s){
    s$components |>
      keep(\(comp) comp$type != "point") |>
      map(\(comp) {
        
        is_inf_lo <- is.infinite(comp$lo)
        is_inf_hi <- is.infinite(comp$hi)
        
        tibble(
          label = s$label,
          lo_disp = if (is_inf_lo) DISPLAY_MIN else comp$lo,
          hi_disp = if (is_inf_hi) DISPLAY_MAX else comp$hi,
          linetype = switch(
            comp$type,
            interval = "solid",
            rational_interval = "dashed",
            irrational_interval = "dotted"
          ),
          lo_closed = comp$lo_closed & !is_inf_lo,
          hi_closed = comp$hi_closed & !is_inf_hi,
          is_inf_lo = is_inf_lo,
          is_inf_hi = is_inf_hi
        )
        
      }) |>
      list_rbind()
  }) |>
  list_rbind()

df_pts <- 
  sets |>
  map(\(s) {
    s$components |>
      keep(\(comp) comp$type == "point") |>
      map(\(comp) tibble(label = s$label, x = comp$value)) |>
      list_rbind()
  }) |>
  list_rbind()

df_endpoints <- 
  rbind(
    df_segs |> filter(!is_inf_lo) |> transmute(label, x = lo_disp, closed = lo_closed, side = "left"),
    df_segs |> filter(!is_inf_hi) |> transmute(label, x = hi_disp, closed = hi_closed, side = "right")
  ) |> 
  mutate(
    bracket = dplyr::case_when(
      side == "left" & closed ~ "[",
      side == "left" & !closed ~ "(",
      side == "right" &  closed ~ "]",
      side == "right" & !closed ~ ")"
    )
  )

endpoint_counts <- df_endpoints |> dplyr::count(label, x)

df_brackets <- 
  df_endpoints |>
  left_join(endpoint_counts, by = c("label", "x")) |>
  filter(n == 1)

df_overlap <- 
  df_endpoints |>
  left_join(endpoint_counts, by = c("label", "x")) |>
  filter(n > 1) |>
  distinct(label, x)

df_segs_plain <- df_segs |> filter(!is_inf_lo & !is_inf_hi)
df_segs_left <- df_segs |> filter( is_inf_lo & !is_inf_hi)
df_segs_right <- df_segs |> filter(!is_inf_lo &  is_inf_hi)
df_segs_both <- df_segs |> filter( is_inf_lo &  is_inf_hi)

df_segs$label <- factor(df_segs$label, levels = y_levels)
df_segs_plain$label <- factor(df_segs_plain$label, levels = y_levels)
df_segs_left$label <- factor(df_segs_left$label, levels = y_levels)
df_segs_right$label <- factor(df_segs_right$label, levels = y_levels)
df_segs_both$label <- factor(df_segs_both$label, levels = y_levels)
df_pts$label <- factor(df_pts$label, levels = y_levels)
df_brackets$label <- factor(df_brackets$label, levels = y_levels)
df_overlap$label <- factor(df_overlap$label, levels = y_levels)

# -- plot ------------------------------------------------------------
p <- 
  ggplot() +
  geom_segment(
    data = df_grid,
    aes(x = DISPLAY_MIN, xend = DISPLAY_MAX, y = label, yend = label),
    color = "#CCCCCC",
    linewidth = 1.5
  ) +
  geom_segment(
    data = df_segs_plain,
    aes(x = lo_disp, xend = hi_disp, y = label, yend = label, linetype = linetype),
    linewidth = 2.0, 
    color = "#FF9999"
  ) +
  geom_segment(
    data = df_segs_left,
    aes(x = lo_disp, xend = hi_disp, y = label, yend = label, linetype = linetype),
    linewidth = 2.0, 
    color = "#FF9999",
    arrow = arrow(ends = "first", length = unit(0.12, "inches"), type = "closed")
  ) +
  geom_segment(
    data = df_segs_right,
    aes(x = lo_disp, xend = hi_disp, y = label, yend = label, linetype = linetype),
    linewidth = 2.0,
    color = "#FF9999",
    arrow = arrow(ends = "last", length = unit(0.12, "inches"), type = "closed")
  ) +
  geom_segment(
    data = df_segs_both,
    aes(x = lo_disp, xend = hi_disp, y = label, yend = label, linetype = linetype),
    linewidth = 2.0,
    color = "#FF9999",
    arrow = arrow(ends = "both", length = unit(0.12, "inches"), type = "closed")
  ) +
  geom_text(
    data = df_brackets,
    aes(x = x, y = label, label = bracket),
    size = 12, 
    color = "#4A4D6D",
    fontface = "bold", 
    family = "mono"
  ) +
  geom_point(
    data = df_overlap,
    aes(x = x, y = label),
    shape = 21, 
    size = 6,
    fill = "white",
    color = "#4A4D6D",
    stroke = 1.5
  ) +
  geom_point(
    data = df_pts,
    aes(x = x, y = label),
    shape = 19,
    size = 6, 
    color = "#4A4D6D"
  ) +
  geom_text(
    data = df_notations,
    aes(x = DISPLAY_MAX + 0.15, y = label, label = notation),
    hjust = 0,
    size = 8,
    color = "#4A4D6D",
    family = "JuliaMono"
  ) +
  annotate("segment", x = -6.0, xend = -5.7, y = 15.8, yend = 15.8, linetype = "solid", linewidth = 1.5, color = "#FF9999") +
  annotate("text", x = -5.6, y = 15.8, label = "interval", hjust = 0, size = 8, color = "#555555", family = "JuliaMono") +
  annotate("segment", x = -3.9, xend = -3.6, y = 15.8, yend = 15.8, linetype = "dashed", linewidth = 1.5, color = "#FF9999") +
  annotate("text", x = -3.5, y = 15.8, label = "rational (\u211a)", hjust = 0, size = 8, color = "#555555", family = "JuliaMono") +
  annotate("segment", x = -1.2, xend = -0.9, y = 15.8, yend = 15.8, linetype = "dotted", linewidth = 1.5, color = "#FF9999") +
  annotate("text", x = -0.8, y = 15.8, label = "irrational (\u211d\\\u211a)", hjust = 0, size = 8, color = "#555555", family = "JuliaMono") +
  annotate("point", x = 2.1, y = 15.8, shape = 19, size = 5, color = "#4A4D6D") +
  annotate("text", x = 2.3, y = 15.8, label = "isolated point", hjust = 0, size = 8, color = "#555555", family = "JuliaMono") +
  annotate("segment", x = 4.8, xend = 5.1, y = 15.8, yend = 15.8, linetype = "solid", linewidth = 1.5, color = "#FF9999") +
  annotate("text", x = 4.8, y = 15.8, label = "[", hjust = 0.5, size = 9, color = "#4A4D6D", fontface = "bold", family = "mono") +
  annotate("text", x = 5.2, y = 15.8, label = "closed endpoint", hjust = 0, size = 8, color = "#555555", family = "JuliaMono") +
  annotate("segment", x = 7.8, xend = 8.1, y = 15.8, yend = 15.8, linetype = "solid", linewidth = 1.5, color = "#FF9999") +
  annotate("text", x = 7.8, y = 15.8, label = "(", hjust = 0.5, size = 9, color = "#4A4D6D", fontface = "bold", family = "mono") +
  annotate("text", x = 8.2, y = 15.8, label = "open endpoint", hjust = 0, size = 8, color = "#555555", family = "JuliaMono") +
  annotate("segment", x = -7.5, xend = -7.5, y = 14, yend = 7.25, arrow = arrow(ends = "last", length = unit(0.08, "inches"), type = "closed"), color = "#4A4D6D", linewidth = 1.5) +
  annotate("text", x = -7.25, y = 10.625, label = "closure-first chain", angle = 90, hjust = 0.5, size = 8.5, color = "#4A4D6D", family = "JuliaMono") +
  annotate("segment", x = -7.5, xend = -7.5, y = 0.5, yend = 6.75, arrow = arrow(ends = "last", length = unit(0.08, "inches"), type = "closed"), color = "#4A4D6D", linewidth = 1.5) +
  annotate("text", x = -7.25, y = 3.625, label = "complement-first chain", angle = 90, hjust = 0.5, size = 8.5, color = "#4A4D6D", family = "JuliaMono") +
  scale_linetype_identity() +
  scale_x_continuous(breaks = seq(-3, 6, by = 1)) +
  coord_cartesian(xlim = c(DISPLAY_MIN, DISPLAY_MAX), clip = "off") +
  labs(
    title = "How many sets can <span style='color:#FF9999'>Closure</span> <br> and <span style='color:#4A4D6D'>Complement</span> generate?",
    subtitle = "The mathematician Kazimierz Kuratowski proved in 1922 that starting from any subset of any topological <br> space, applying 
    <span style='color:#FF9999'>closure (cl)</span> and <span style='color:#4A4D6D'>complement (co)</span> repeatedly **produces at most 14
    distinct sets** \u2014 never more.<br>The set **A = (0,1) \u222a (1,2) \u222a {3} \u222a ([4,5] \u2229 \u211a)** is the canonical example on \u211d that hits all 14.",
    caption = "Visualization: J. G. Oliveira",
    x = NULL,
    y = NULL
  ) +
  theme_minimal(base_size = 20) +
  theme(
    plot.title = element_markdown(
      family = "RubikMonoOne",
      size = 90,
      color = "#181818",
      margin = margin(b = 60),
      lineheight = 1.1, 
      hjust = 0
    ),
    plot.subtitle = element_markdown(
      family = "JuliaMono",
      size = 30,
      color = "#333333",
      margin = margin(b = 110),
      lineheight = 1.4, 
      hjust = 0
    ),
    plot.caption = element_text(size = 24, color = "#888888", hjust = 1.65, vjust = 0, family = "JuliaMono", margin = margin(t = 40)),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    axis.text.x = element_text(size = 28, color = "#4A4D6D", face = "bold", family = "ShareTechMono", hjust = 1),
    axis.text.y = element_text(size = 28, color = "#4A4D6D", face = "bold", family = "ShareTechMono", hjust = 1),
    axis.ticks = element_blank(),
    axis.line.y = element_blank(),
    plot.margin = margin(100, 700, 100, 100),
    plot.title.position   = "plot",
    plot.caption.position = "plot"
  )

# -- save ----------------------------------------------------------------------
output_path <- "portfolio/data-viz/math-series/kuratowski-closure-complement/files/plot.png"
ggsave(output_path, p, width = 30, height = 25, dpi = 300)
