#/bin/csh -f
set scripts = "/users/ashahiny/scripts"
source "/users/ashahiny/scripts/tech/avago16nm/avago16nm.tech"

if ( $#argv == 0 ) then
            echo "Argument is missing"
                echo "Usage - ./gen_flow.csh cut_dir"
                    echo "Set variable unroll to yes to execute unroll as well"
                            exit (0)
                            endif

set cut = $argv[1];

ln -s ${compiler_home}/${compiler_cmd} .  ;
setenv $compiler_var  $compiler_home ;

foreach i ( `cat ../doc/${cut}.inst` )
    echo "Generating $i" ;
        ######## SEARCH FOR COMPILER COMMAND AND EXECUTE  #######
            set cmd = `cat ${lib_path}/*json | grep -A 1 ${i} | grep cmd | cut -d '"' -f4 | sed -e "s|/auto/tools/libraries/avago/16nm/DK_PN99_2014_03_25.to_Memoir/memory/mem16_front_end_compiler_tools_memory_model_generator/||g"`  ;
                echo $cmd
                    ./${cmd} ;

end

