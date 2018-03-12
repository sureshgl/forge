package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_elam_identifierContext;

public class Type_elam_identifierContextExt extends AbstractBaseExt {

	public Type_elam_identifierContextExt(Type_elam_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_elam_identifierContext getContext() {
		return (Type_elam_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_elam_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_elam_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_elam_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
