<ul {if !$sub}class="nav"{else}class="ul-sub"{/if}>
    {if !$sub}<li><a href="?c=catalog"><span class="glyphicon glyphicon-th-list btn-xs"></span> Все школы</a></li>{/if}
{section name=i loop=$categories}
    <li>
        <a class="col-xs-10" href="?c=catalog&cid={$categories[i].ID}" data-toggle="tooltip" title="{$categories[i].TITLE}">
            {if !$sub}<span class="glyphicon glyphicon-book btn-xs"></span>{/if}
            {$categories[i].TITLE}
        </a>
        <a class="col-xs-2" data-toggle="tooltip" data-original-title="Редактировать категорию" href="?c=catalog&cid={$categories[i].ID}&act=edit"><span class="glyphicon glyphicon-pencil btn-xs"></span></a>
        {if $categories[i].SUB}
            {include file="menu2.tpl" categories=$categories[i].SUB sub=true}
        {/if}
    </li>
{/section}
</ul>