library(fs)
library(purrr)
library(rmarkdown)
library(dplyr)
library(stringr)

repo_folder <- "dsb_repo"
repo <- "https://github.com/rstudio-education/datascience-box"
if(!dir_exists(repo_folder)) git2r::clone(repo, repo_folder)

slides_folder <- "slides"
if(!dir_exists(slides_folder)) dir_create(slides_folder)

source_slides <- path(repo_folder, "course-materials", "_slides")

c("setup.Rmd", "slides.css", "xaringan-themer.css", "xaringan-themer.R", "dsbox-hex.png") %>% 
  map(~{
    try(
      file_copy(path(source_slides, .x), path(slides_folder))  
    )
  })


c("u1-d01-welcome", "u2-d02-ggplot2") %>% 
#c("u1-d01-welcome") %>% 
  map(~{
    try(
      dir_copy(path(source_slides, .x), path(slides_folder))
    )
    files_folder <- path(slides_folder, .x, paste0(.x, "_files"))
    if(dir_exists(files_folder)) dir_delete(files_folder)
    html_file <- path(slides_folder, .x, .x, ext = "html")
    if(file_exists(html_file)) file_delete(html_file)
    print(html_file)
  })

dir_info(slides_folder, recurse = 3, glob = "*.Rmd") %>% 
  filter(!str_detect(path, "setup")) %>%
  pull(path) %>% 
  walk(render, output_file = "index.html")

docs_slides <- path("docs/slides")
if(dir_exists(docs_slides)) {
  dir_delete(docs_slides)
  dir_copy("slides", docs_slides)
}
