

df_token <- 
    purrr::map_chr(fs::dir_ls(here::here("posts"), type = "directory"), ~{
    readr::read_file(paste0(.x, "/index.qmd"))
  }) |> 
  paste(collapse = " ") |> 
  stringr::str_split_1(stringr::regex("---|```", ignore_case = TRUE, multiline = TRUE, dotall = TRUE)) |> 
  tibble::as_tibble_col(column_name = "text") |> 
  dplyr::filter(!stringr::str_detect(text, "^\\{|title:")) |> 
  dplyr::mutate(
    text = textclean::replace_html(text, symbol = FALSE),
    text = textclean::replace_url(text),
    text = stringr::str_remove_all(text, "\\d")
  ) |> 
  tidytext::unnest_tokens(word, text) |> 
  dplyr::mutate(word = textstem::lemmatize_words(word)) |> 
  dplyr::anti_join(tidytext::stop_words, by = "word") |> 
  dplyr::count(word, name = "freq") |> 
  dplyr::mutate(len = stringr::str_length(word)) |> 
  dplyr::filter(len > 2)

wordcloud2::wordcloud2(df_token, hoverFunction = "off")

