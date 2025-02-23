set -e

VERSION=0.4.5

# for every model
for MODEL_NAME in en_use_md en_use_lg xx_use_md xx_use_lg xx_use_cmlm xx_use_cmlm_br en_use_cmlm_md en_use_cmlm_lg
do
    mkdir -p models/$MODEL_NAME
    # create the nlp and save to disk
    python create.py $MODEL_NAME
    # overwrite meta.json
    cp spacy_universal_sentence_encoder/meta/$MODEL_NAME.json models/$MODEL_NAME/meta.json

    # create the package
    mkdir -p packages
    python -m spacy package models/$MODEL_NAME packages --force -m spacy_universal_sentence_encoder/meta/$MODEL_NAME.json
    # overwrite meta.json (relax spacy_version constraints)
    cp spacy_universal_sentence_encoder/meta/$MODEL_NAME.json packages/$MODEL_NAME-$VERSION/meta.json
    pushd packages/$MODEL_NAME-$VERSION
    # zip it
    python setup.py sdist
    # install the tar.gz from dist folder
    pip install dist/$MODEL_NAME-${VERSION}.tar.gz
    popd
done
