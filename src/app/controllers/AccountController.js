const User = require('../models/User')

class AccountController{
    //[GET] - /account/showall 
    showall(req, res){
        User.find({})
            .then(users => res.json(users))
            .catch(err => res.status(500).json({ error: err.message }))
    }

    //[POST] - /account/login 
    login(req, res){
        User.findOne({email: req.body.email})
            .then(users => {
                if(!users){
                    return res.status(400).json({error: 'User not found'})
                }
                if(users.password_hash !== req.body.password_hash){
                    return res.status(400).json({error:'Invalid Password'})
                }
                res.json(users)
            })
            .catch(err => res.status(500).json({ error: err.message }))
    }

    //[POST] - /account/create 
    create(req, res){
        const user = new User(req.body)
        user.save()
        .then(() => res.json('Account Created'))
        .catch(err => res.status(500).json({error: err.message}))
    }
}

module.exports = new AccountController()