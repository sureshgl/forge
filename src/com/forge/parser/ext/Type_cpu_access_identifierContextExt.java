package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_cpu_access_identifierContext;

public class Type_cpu_access_identifierContextExt extends AbstractBaseExt {

	public Type_cpu_access_identifierContextExt(Type_cpu_access_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_cpu_access_identifierContext getContext() {
		return (Type_cpu_access_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_cpu_access_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_cpu_access_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_cpu_access_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
