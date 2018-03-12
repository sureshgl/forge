package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_tContext;

public class PortCap_tContextExt extends AbstractBaseExt {

	public PortCap_tContextExt(PortCap_tContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_tContext getContext() {
		return (PortCap_tContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_t());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_tContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_tContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
