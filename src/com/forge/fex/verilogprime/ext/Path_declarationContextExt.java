package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Path_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Path_declarationContextExt extends AbstractBaseExt {

	public Path_declarationContextExt(Path_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Path_declarationContext getContext() {
		return (Path_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).path_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Path_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Path_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}