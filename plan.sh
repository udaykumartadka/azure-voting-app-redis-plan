pkg_name=azure-voting-app-redis
pkg_origin=kbhimanavarjula
pkg_version="0.1.0"
pkg_maintainer="Krishna Bhimanavarjula <kbhimanavarjula>"
pkg_license=('Apache-2.0')
pkg_source="https://github.com/kbhimanavarjula/azure-voting-app-redis"
#pkg_source=false
pkg_deps=(core/coreutils core/gcc-libs core/openssl)
pkg_build_deps=(core/bundler core/cacerts core/coreutils core/git) 
# pkg_filename="${pkg_name}-${pkg_version}.tar.gz"
# pkg_shasum="TODO"
# pkg_deps=(core/glibc)
# pkg_build_deps=(core/make core/gcc)
# pkg_lib_dirs=(lib)
# pkg_include_dirs=(include)
pkg_bin_dirs=(bin)
# pkg_pconfig_dirs=(lib/pconfig)
pkg_svc_run="azure-voting-app-redis -o 0.0.0.0 --config  $pkg_svc_config_path/config.yml"
# pkg_exports=(
#   [host]=srv.address
#   [port]=srv.port
#   [ssl-port]=srv.ssl.port
# )
pkg_exposes=()
# pkg_binds=(
#   [database]="port host"
# )
# pkg_binds_optional=(
#   [storage]="port host"
# )
# pkg_interpreters=(bin/bash)
pkg_svc_user="hab"
pkg_svc_group="$pkg_svc_user"
# pkg_description="Some description."
# pkg_upstream_url="http://example.com/project-name"

do_download()  
{
        build_line "do_download() =================================================="  
        cd ${HAB_CACHE_SRC_PATH}

        build_line "\$pkg_dirname=${pkg_dirname}"  
        build_line "\$pkg_filename=${pkg_filename}"

        if [ -d "${pkg_dirname}" ];  
        then  
            rm -rf ${pkg_dirname}  
        fi

        mkdir ${pkg_dirname}  
        cd ${pkg_dirname}  
        GIT_SSL_NO_VERIFY=true git clone --branch master https://github.com/kbhimanavarjula/azure-voting-app-redis.git  
        return 0  
}


do_clean()  
{
        build_line "do_clean() ===================================================="  
        return 0  
}

do_unpack()  
{
        # Nothing to unpack as we are pulling our code straight from github  
        return 0  
}

do_build()  
{
    build_line "do_build() ===================================================="

    # Maven requires JAVA_HOME to be set, and can be set via:  
    #export JAVA_HOME=$(hab pkg path core/jdk8)

    cd ${HAB_CACHE_SRC_PATH}/${pkg_dirname}/${pkg_filename}  
#    mvn package  
}

do_install()  
{
        build_line "do_install() =================================================="

        # Our source files were copied over to the HAB_CACHE_SRC_PATH in do_build(),  
        # so now they need to be copied into the root directory of our package through  
        # the pkg_prefix variable. This is so that we have the source files available  
        # in the package.

        local source_dir="${HAB_CACHE_SRC_PATH}/${pkg_dirname}/${pkg_filename}"  
        #local webapps_dir="$(hab pkg path core/tomcat8)/tc/webapps"  
        #cp ${source_dir}/target/${pkg_filename}.war ${webapps_dir}/

        # Copy our seed data so that it can be loaded into Mongo using our init hook  
        cp ${source_dir}/azure-vote/azure-vote/config_file.cfg  $(hab pkg path ${pkg_origin}/azure-voting-app-redis)/  
}
