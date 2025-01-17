<?php

class AdminHomeController extends AdminController {
    public function __construct() {
        parent::__construct();
    }

    public function SaveVid(){
        Config::getInstance()->set('vid', $this->post['vid']);
        $this->Head('?c=home');
    }

    public function ShowVid(){
        if (isset($this->get['id'])){

        }

        $this->content = $this->SetTemplate('vid.tpl');
    }

    public function SaveSpecItem(){
        $params = array(
            'SCH_ID'  => $this->post['school_id'],
            'TEXT' => $this->post['text'],
        );


        if ($this->get['id'] > 0){
            $this->db->update('agcms_spec', $params, 'ID = ' . $this->get['id']);
        } else {
            $this->db->insert('agcms_spec', $params);
        }

        $this->Head('?c=home&act=spec');
    }

    public function ShowSpecItem(){
        if ($this->get['id'] > 0) {
            $sql = "SELECT s.*, i.TITLE, i.ID AS SCH_ID FROM agcms_spec s
            LEFT JOIN agcms_catalog_i i ON s.SCH_ID = i.ID WHERE s.ID = " . $this->get['id'];
            $item = $this->db->select($sql, array('single_array' => true));
            $this->assign(array(
                'item'  => $item,
            ));
        }
        $this->content = $this->SetTemplate('spec-item.tpl');
    }

    public function ShowSpec(){
        if (isset($this->get['id'])){
            $this->ShowSpecItem();
        } else {

            $sql = "SELECT s.*, i.TITLE FROM agcms_spec s
            LEFT JOIN agcms_catalog_i i ON s.SCH_ID = i.ID";
            $items = $this->db->select($sql);
            $this->assign(array(
                'items'  => $items,
            ));
            $this->content = $this->SetTemplate('spec.tpl');
        }
    }

    public function DelSpec(){
        $sql = "DELETE FROM agcms_spec WHERE ID = " . $this->get['id'];
        $this->db->query($sql);
        $this->Head('?c=home&act=spec');
    }

    public function SavePopularItem(){
        $params = array(
            'POPULAR_ID'  => $this->post['popular_id'],
        );
        if ($this->get['id'] > 0){
            $this->db->update('agcms_popular', $params, 'ID = ' . $this->get['id']);
        } else {
            $this->db->insert('agcms_popular', $params);
        }
        $this->Head('?c=home&act=popular');
    }

    public function ShowPopularItem(){
        if ($this->get['id'] > 0) {
            $sql = "SELECT p.*, c.TITLE, c.ID AS COURSE_ID FROM agcms_popular p
            LEFT JOIN agcms_catalog_courses c ON c.ID = POPULAR_ID WHERE p.ID = " . $this->get['id'];
            $item = $this->db->select($sql, array('single_array' => true));
            $this->assign(array(
                'item'  => $item,
            ));
        }
        $this->content = $this->SetTemplate('popular-item.tpl');
    }

    public function ShowPopular(){
        if (isset($this->get['id'])){
            $this->ShowPopularItem();
        } else {
            $sql = "SELECT p.*, c.TITLE, i.TITLE AS SH_TITLE, c.ID AS COURSE_ID FROM agcms_popular p
            LEFT JOIN agcms_catalog_courses c ON c.ID = p.POPULAR_ID
            LEFT JOIN agcms_catalog_i i ON i.ID = c.SH_ID
            ";
            $items = $this->db->select($sql);

            $this->assign(array(
                'items'  => $items,
            ));
            $this->content = $this->SetTemplate('popular.tpl');
        }
    }

    public function DelPopular(){
        $sql = "DELETE FROM agcms_popular WHERE ID = " . $this->get['id'];
        $this->db->query($sql);
        $this->Head('?c=home&act=popular');
    }

    public function ShowRews(){

        if (isset($this->get['id']) && $this->get['id'] >0){
            $this->ShowRew();
        } else {

            $sql = 'SELECT * FROM agcms_services_rews WHERE SERVICE_ID = 0';
            $items = $this->db->select($sql);
            $this->assign(array(
                'items'                     => $items,
            ));
            $this->content = $this->SetTemplate('rews.tpl');

        }
    }

    public function SaveRew(){
        $params = array(
            'SERVICE_ID' => 0,
            'TITLE' => $this->post['title'],
            'REW' => $this->post['rew'],
            'RFROM' => $this->post['rfrom'],

        );

        $upload_path = UPLOAD_IMAGES_DIR.'services/';
        $photo1 = Func::getInstance()->UploadFile($_FILES["photo"]['name'],$_FILES["photo"]['tmp_name'], $upload_path);

        if ($photo1 !== false){
            $params['PHOTO'] = $photo1;
        }

        if (isset($this->get['id'])){
            $this->db->update('agcms_services_rews', $params, "ID = " . $this->get['id']);
        } else {
            $this->db->insert('agcms_services_rews', $params);
        }
        $this->Head('?c=home&act=rews');
    }

    public function ShowRew(){
        if (isset($this->get['id']) && $this->get['id'] > 0){
            $sql = "SELECT * FROM `agcms_services_rews` WHERE ID = " . $this->get['id'];
            $item = $this->db->select($sql, array('single_array' => true));
            $this->assign(array(
                'item'      => $item,
            ));
        }
        $this->content = $this->SetTemplate('rew.tpl');
    }

    public function DelRews(){

    }

    public function Index(){


        if (isset($this->post['vid'])){
            $this->SaveVid();
        }

        if (isset($this->post['save-spec-item'])){
            $this->SaveSpecItem();
        }
        if (isset($this->post['save-popular-item'])){
            $this->SavePopularItem();
        }

        if (isset($this->post['save-rew'])){
            $this->SaveRew();
        }

        $this->widget_left_top .=$this->fetch('menu.tpl');
        $this->page_title = 'Главная страница';




        if ($this->get['act'] == 'vid'){
            $this->ShowVid();

        }
        elseif ($this->get['act'] == 'spec'){
            $this->ShowSpec();
        }
        elseif ($this->get['act'] == 'popular'){
            $this->ShowPopular();
        }
        elseif ($this->get['act'] == 'del-spec'){
            $this->DelSpec();
        }
        elseif ($this->get['act'] == 'del-popular'){
            $this->DelPopular();
        }
        elseif ($this->get['act'] == 'rews'){
            $this->ShowRews();
        }
        else{
            $this->content = $this->SetTemplate('index.tpl');
        }



        return $this->content;
    }
}
?>