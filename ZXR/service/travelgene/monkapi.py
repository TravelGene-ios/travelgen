import sys
sys.path.append("travelgene/pymonk-master/")
from travelgene import app
from travelgene import mongo
from flask import Flask, render_template, session, redirect, url_for, escape, request
import json
import flask_debugtoolbar
from flask_debugtoolbar import DebugToolbarExtension
from flask.ext.cors import CORS
from flask.ext.pymongo import PyMongo
import random
import monk.core.api as ms
from monk.roles.configuration import default_config
from monk.math.cmath import sign0

is_initialized = False
def init_database():
    ents = ms.convert_entities()
    stemTS = ms.yaml2json('travelgene/pymonk-master/examples/turtle_scripts/turtle_stem.yml')
    stemT = ms.create_turtle(stemTS)
    # print stemT.generic()
    ents = ms.load_entities()
    for ent in ents:
        add_label(ent._id,'likeTravel','N')
    # print len(ents)
    # print ents[0].generic()
    fields=['title', 'comment', 'desc']
    print [stemT.predict(ent, fields) for ent in ents]
    stemT.save()
    [ent.save() for ent in ents]

def init_monk():
    config=default_config()
    ms.initialize(default_config())
    is_initialized = True
    likeTS = ms.yaml2json('travelgene/pymonk-master/examples/turtle_scripts/turtle_like.yml')
    # print likeTS
    likeT = ms.create_turtle(likeTS)
    likeT.save()

def add_label(ent_id,field,value):
    ent = ms.load_entity(ent_id)
    ent._setattr(field,value)
    ms.crane.entityStore.save_one(ent)

def add_data_to_model(turtle_name,ent_id,creator='monk'):
    ms.add_data(turtle_name,creator,ent_id);

def train(turtleName,creator='monk'):
    trainer = ms.load_turtle(turtleName,creator)
    trainer.train()
    return trainer

def predict(trainer,ent_id,creator='monk'):#How?
    ent = ms.load_entity(ent_id)
    print ent.desc
    # return sign0(trainer.pandas[0].predict(ent))
    score=trainer.pandas[0].predict(ent)
    print score
    return score


def get_recommended_place(collection_name,skip_num=0,request_num=5):  
    #print collection_name
    ents = ms.load_entities(collectionName = collection_name)
    user_turtle = 'likeTravel'
    trainer = train(user_turtle,'monk')
    rank=[]
    for ent in ents:
	rank.append((ent._id,predict(trainer,ent._id)))
    sorted_by_score = sorted(rank, key=lambda tup: tup[1])
    rst = []
    for r in sorted_by_score:
	ent = ms.load_entity(r[0])
        e = {}
        # e['place_id'] = ent.place_id
        e['_id'] = ent._id
        e['img_url'] = ent.img_url
        e['desc'] = ent.desc
        rst.append(e)
   # print len(ents)
    return rst[skip_num:skip_num+request_num]

def update_recommended_place(collection_name,ent_id,value,creator='monk',skip_num=0):
    user_turtle = 'likeTravel'
    # get turtle name from creator? need to updpate database 'user'
    # print collection_name, "collection"
    ent_id = ent_id
    add_label(ent_id,'likeTravel',value)

    add_data_to_model(user_turtle,ent_id,creator)
    return get_recommended_place(collection_name,skip_num)

# def get_entity_id(collection_name,place_id):
#     res = mongo.db[collection_name].find_one({'place_id':place_id})
#     return res['_id']

def is_initilized():
    return is_initilized
