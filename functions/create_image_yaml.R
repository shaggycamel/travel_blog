#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

create_image_yaml <- function(media_dir_path){
  
  # Append "media_data" to the end of directory path
  media_dir_path <- paste0(media_dir_path, "/media_data/")
  
  # Get names of all directories in media_data dir
  image_dirs <- fs::dir_info(media_dir_path) |> 
    dplyr::mutate(dir = stringr::str_remove(path, media_dir_path), .after = path)

  # loop through image dirs and create yaml files
  for(dir in image_dirs$dir){
    
    # Get names of images in image directories
    images <- fs::dir_info(paste0(media_dir_path, dir, "/")) |> 
      dplyr::filter(stringr::str_ends(path, ".jpg|.JPG")) |> 
      dplyr::mutate(file_name = stringr::str_remove(path, paste0(media_dir_path, dir, "/")), .after = path) |> 
      dplyr::arrange(birth_time)
    
    # Create strings describing images in directories
    img_ls <- purrr::map(images$file_name, ~ {
      t_dir <- stringr::str_to_title(stringr::str_replace_all(dir, "_", " "))
      stringr::str_glue('
                        - image: "media_data/{dir}/{.x}"
                          caption: "{t_dir}"
                        \n'
      )
    })
  
    # Write description to yaml files
    readr::write_lines(img_ls, paste0(media_dir_path, dir, "/", dir, ".yml"))
    
  }
}

create_image_yaml(paste0("/Users/fred/git/travel_blog/posts/", args[1]))

