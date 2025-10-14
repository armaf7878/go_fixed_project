const { model } = require('mongoose');
const Service = require('../models/Service')
class ServiceController{
    //GET - /service/get
    async showall(req, res){
        try {
            const services = await Service.find()
            res.status(200).json(services);
        } catch (error) {
            res.status(500).json({ message: 'Lỗi server' });
        }
    }
    //GET - /service/add
    async add(req, res){
        try {
            const { name, base_price, icon_url } = req.body;
            const newService = new Service({
                name,
                base_price,
                icon_url,
                kind_services: 'simple_services'
            })
            const savedService = await newService.save();

            res.status(201).json(savedService);
        } catch (error) {
            console.error(error)
            res.status(500).json({ message: 'Lỗi khi tạo service' })
        }
    }
    //GET - /service/delete
    async delete(req, res){
        try {
            const { id } = req.params;
            const result = await Service.findByIdAndDelete(id)
            if (!result) {
                return res.status(404).json({ message: 'Không tìm thấy service' });
            }
            res.json({ message: 'Đã xóa thành công', result });
        } catch (error) {
            res.status(500).json({ message: 'Lỗi server' });
        }
    }

}

module.exports = new ServiceController()