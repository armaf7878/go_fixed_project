const { model } = require('mongoose');
const Service = require('../models/Service')
class ServiceController{
    //GET - /home/service
    async showall(req, res){
        try {
            const services = await Service.find()
            res.status(200).json(services);
        } catch (error) {
            res.status(500).json({ message: 'Lỗi server' });
        }
    }
}

module.exports = new ServiceController()