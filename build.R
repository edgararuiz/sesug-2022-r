library(fs)
library(purrr)
library(rmarkdown)
library(dplyr)
library(stringr)

repo_folder <- "dsb_repo"
repo <- "https://github.com/rstudio-education/datascience-box"
if(!dir_exists(repo_folder)) git2r::clone(repo, repo_folder)

slides_folder <- "slides_folder"
if(!dir_exists(slides_folder)) dir_create(slides_folder)
#dir_copy(path(repo_folder, "course-materials", "_slides"), slides_folder)

source_slides <- path(repo_folder, "course-materials", "_slides")


c("setup.Rmd", "slides.css", "xaringan-themer.css", "xaringan-themer.R", "dsbox-hex.png") %>% 
  map(~{
    try(
      file_copy(path(source_slides, .x), path(slides_folder))  
    )
  })


c("u1-d01-welcome") %>% 
  map(~{
    try(
      dir_copy(path(source_slides, .x), path(slides_folder))
    )
  })




dir_info(slides_folder, recurse = 3, glob = "*.Rmd") %>% 
  filter(!str_detect(path, "setup")) %>%
  pull(path) %>% 
  walk(render)
