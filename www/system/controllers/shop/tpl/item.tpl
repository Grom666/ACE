<form id="item-form" action="" method="post" enctype="multipart/form-data">
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title text-uppercase">
                <span class="glyphicon glyphicon-duplicate"></span>
                {if $new}Создание нового материала{else}Редактирование материала{/if}
                {if !$new}
{*                    <span class="pull-right text-lowercase">
                            <a href="?c=shop&act=new" class="btn btn-info btn-xs" data-toggle="tooltip" title="" data-original-title="Создать новвый материал"><span class="glyphicon glyphicon-copy"></span></a>
                            <a href="?c=shop&act=del-item&id={$item_id}&cid={$item_parents[0]}" class="btn btn-danger btn-xs confirm" data-toggle="tooltip" title="" data-original-title="Удалить материал"><span class="glyphicon glyphicon-remove"></span></a>
                    </span>*}
                {/if}
                <div class="pull-right">
                    <a class="btn btn-primary btn-xs" href="?c=shop&cid={$smarty.get.cid}"><span class="glyphicon glyphicon-arrow-left"></span></a>
                    <button type="submit" class="btn btn-primary btn-xs"><span class="glyphicon glyphicon-floppy-disk"></span> Сохранить</button>
                </div>
            </h3>
        </div>
        <div class="panel-body">
            {if !$new}
                <div class="alert alert-info">
                    <div class="row">
                        <span class="col-sm-3 text-right">URL материала:</span>
                        <span class="col-sm-9"><a target="_blank" href="{$site_url}shop/{$item_alias}">{$site_url}shop/{$item_alias}</a></span>
                    </div>
                    <div class="row">
                        <span class="col-sm-3 text-right">Короткая ссылка:</span>
                        <span class="col-sm-9"><a target="_blank" href="{$site_url}shop/{$item_id}">{$site_url}shop/{$item_id}</a></span>
                    </div>
                </div>
            {/if}
            <div class="tabs">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#tab-common" data-toggle="tab">Общие</a></li>
                    <li><a href="#tab-content" data-toggle="tab">Содержимое</a></li>
                    <li><a href="#tab-price" data-toggle="tab">Товар</a></li>
                    <li><a href="#tab-options" data-toggle="tab">Опции</a></li>
                    <li><a href="#tab-links" data-toggle="tab">Связи</a></li>
                    <li><a href="#tab-images" data-toggle="tab">Изображения</a></li>
                    <li><a href="#tab-files" data-toggle="tab">Файлы</a></li>
                    <li><a href="#tab-other" data-toggle="tab">Другое</a></li>
                </ul>
                <div class="tab-content">
                    <div id="tab-common" class="tab-pane fade in active">
                        <h3>Общие данные</h3>
                        <p>{include file="item-common.tpl"}</p>
                    </div>
                    <div id="tab-content" class="tab-pane fade">
                        <h3></h3>
                        <p>{include file="item-content.tpl"}</p>
                    </div>
                    <div id="tab-price" class="tab-pane fade">
                        <h3></h3>
                        <p>{include file="item-price.tpl"}</p>
                    </div>
                    <div id="tab-options" class="tab-pane fade">
                        <h3></h3>
                        <p>{include file="item-options.tpl"}</p>
                    </div>
                    <div id="tab-links" class="tab-pane fade">
                        <h3></h3>
                        <p>{include file="item-links.tpl"}</p>
                    </div>
                    <div id="tab-images" class="tab-pane fade">
                        <h3></h3>
                        <p>{include file="item-images.tpl"}</p>
                    </div>
                    <div id="tab-files" class="tab-pane fade">
                        <h3></h3>
                        <p>{include file="item-files.tpl"}</p>
                    </div>
                    <div id="tab-other" class="tab-pane fade">
                        <h3></h3>
                        <p>{include file="item-fields.tpl"}</p>
                    </div>
                </div>
            </div>

            <div class="pull-right"><button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk"></span> Сохранить</button></div>

        </div>
    </div>
</form>
<script type="text/javascript" src="{$html_plugins_dir}init_mce.js"></script>
<script>
    {literal}
        $("a.fancybox").fancybox();
    {/literal}

    {literal}
    $(document).ready(function(){
/*        $.cleditor.set_rfm('/filemanager');
        var  controls=
        "bold italic underline strikethrough subscript superscript | font size " +
                "style | color highlight removeformat | bullets numbering | outdent " +
                "indent | alignleft center alignright justify | " +
                "rule image link unlink | source";
        $("#short_content").cleditor({'controls':controls});
        $("#content").cleditor({'controls':controls});*/

    });

    {/literal}
    var alias_page_new = false;
    if ($("#alias").val()==''){
        alias_page_new = true;
    }
    $("#title").change(function(){
        if (alias_page_new){
            var str = $(this).val();
            var str2 = SetTranslitRuToLat(str);
            $("#alias").val(str2);
        }
    });
    $("#item-form").submit(function(){
        var alias_page = $(this).find("input[name='alias']").val();
        if (alias_page != ''){
            var pattern = /^[a-z0-9_-]+$/i;
            if (!pattern.test(alias_page)){
                alert('Алиас содержит недопустимые символы');
                return false;
            }
        }
        var chs = $(this).find("input[name='parents[]']:checked");
        if (chs.length==0){
            alert("Необходимо выбрать хотя бы одну категорию");
            return false;
        }

        var options =[];
        $("#options .option-item:checked").each(function(i,e){
            var parameter = new Object();
            parameter.id = $(e).val();
            parameter.option_id = $(e).attr("data-option");
            parameter.method = $("#param_method_"+parameter.id).val();
            parameter.price = $("#param_price_"+parameter.id).val();
            parameter.article = $("#param_article_"+parameter.id).val();
            options.push(parameter);
        });
        $("#options_json").text(JSON.stringify(options));

        var links = [];
        $("#links li").each(function(i,e){
            links.push($(this).attr("data-id"));
        });
        $("#input-links").val(links.join());
        //return false;
    });
    $(".confirm").click(function(e){
        if (!confirm("Вы уверенны что хотите это сделать?")){
            e.preventDefault();
        }
    });

    $("#options input[type='checkbox']").click(function(){

    });

</script>
